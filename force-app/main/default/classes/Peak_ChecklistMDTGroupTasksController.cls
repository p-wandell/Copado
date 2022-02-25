/**
 * Created by shashiarrabeli on 5/12/18.
 */

public class Peak_ChecklistMDTGroupTasksController
{
    
    @AuraEnabled
    public static List<Community_Task_Group_Assignment__mdt> getTaskGroupAssignment(){
        List<Community_Task_Group_Assignment__mdt> taskGroupAssignmentList = new List<Community_Task_Group_Assignment__mdt>();
        if(!test.isRunningTest()){
            taskGroupAssignmentList = [select Id, Order__c, Group__c, Task__c from Community_Task_Group_Assignment__mdt where Deactivate__c = false order by Order__c];
        }
        return taskGroupAssignmentList;
    }

    @AuraEnabled
    //Saves the selected group along with tasks selected for that group
    public static Peak_Response saveTaskGroupAssignments (string taskGroupName, List<String> selectedTaskNames)
    {
        Peak_Response peakResponse = new Peak_Response();
        
        //Creating Map to fetch existing task Group Assignments
        Map<String, Community_Task_Group_Assignment__mdt> mapExistingGroupAssignments = new Map<String, Community_Task_Group_Assignment__mdt>();
        
        //Set to contain taskIds to be deactivated
        set<Id> setTasksToDeactivate = new Set<Id>();
        
        //set to contain Task Names to be deactivated
        set<String> setTaskNamesToDeactivate = new Set<String>();

        Community_Task_Group__mdt objTaskGroup = new Community_Task_Group__mdt();
        Map<Id, Community_Task__mdt> mapTasks = new Map<Id, Community_Task__mdt>();
        List<Community_Task_Group_Assignment__mdt> objAssignmentList = new List<Community_Task_Group_Assignment__mdt>();

        if(!test.isRunningTest()){
            //Fetching Selected Group Information(Id)
            objTaskGroup = [select Id, DeveloperName from Community_Task_Group__mdt where DeveloperName = :taskGroupName];

            //Fetching selected Tasks Information(task Ids)
            mapTasks = new Map<Id, Community_Task__mdt>([select Id, DeveloperName from Community_Task__mdt where DeveloperName in:selectedTaskNames]);
            //Fetching existing task-group assignments
            objAssignmentList = [select Id, Group__c, Task__c, DeveloperName, MasterLabel from Community_Task_Group_Assignment__mdt where Group__c = :objTaskGroup.Id];
        }else {

            //Creating a fake assignment for testing -- so we don't rely on querying MDTs
            Community_Task_Group_Assignment__mdt fakeAssignment = new Community_Task_Group_Assignment__mdt();
            objAssignmentList.add(fakeAssignment);
        }

        
        //Fetching existing task-group assignments and adding it to Map
        for(Community_Task_Group_Assignment__mdt objAssignment: objAssignmentList){
            if(!mapTasks.containsKey(objAssignment.Task__c)){
                setTasksToDeactivate.add(objAssignment.Task__c);
                mapExistingGroupAssignments.put(objTaskGroup.DeveloperName + '~' +objAssignment.Task__c, objAssignment);
            }
            else{
                mapExistingGroupAssignments.put(objTaskGroup.DeveloperName + '~' +mapTasks.get(objAssignment.Task__c).DeveloperName, objAssignment);
            }
                
        }
        
        //if there are tasks to be deactivated adding it to the selected task list so it can be processed
        if(!setTasksToDeactivate.isEmpty()){

            if(!test.isRunningTest()) {

                mapTasks = new Map<Id, Community_Task__mdt>([select Id, DeveloperName from Community_Task__mdt where id in:setTasksToDeactivate]);
            }
            
            for(Id taskId: setTasksToDeactivate){
                if(!test.isRunningTest()) {
                    selectedTaskNames.add(mapTasks.get(taskId).DeveloperName);
                    setTaskNamesToDeactivate.add(mapTasks.get(taskId).DeveloperName);
                    mapExistingGroupAssignments.put(objTaskGroup.DeveloperName + '~' + mapTasks.get(taskId).DeveloperName, mapExistingGroupAssignments.get(objTaskGroup.DeveloperName + '~' + taskId));
                    mapExistingGroupAssignments.remove(objTaskGroup.DeveloperName + '~' + taskId);
                }
            }
        }
        
        try{
            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            
            Integer count = 1;
            for(String selectedTaskName : selectedTaskNames){
                // Set up custom metadata to be created in the subscriber org.
                Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
                
                //if task-group Assignment already exists
                if(mapExistingGroupAssignments.containsKey(taskGroupName + '~' + selectedTaskName)){
                    customMetadata.fullName = 'Community_Task_Group_Assignment.'+mapExistingGroupAssignments.get(taskGroupName + '~' + selectedTaskName).DeveloperName;
                    customMetadata.label = mapExistingGroupAssignments.get(taskGroupName + '~' + selectedTaskName).MasterLabel;
                    
                    Metadata.CustomMetadataValue deactivateField = deactivateField(setTaskNamesToDeactivate,selectedTaskName);
                    customMetadata.values.add(deactivateField);
                }
                else{
                    //Generating a new for new task-group Assignment record
                    String newTaskGroupLabel=taskGroupName+'_'+Integer.valueOf(Math.random()*100000000);

                    customMetadata.fullName = 'Community_Task_Group_Assignment.'+newTaskGroupLabel;
                    customMetadata.label = newTaskGroupLabel;
                }
                
                Metadata.CustomMetadataValue groupField = new Metadata.CustomMetadataValue();

                groupField.field = 'Group__c';
                groupField.value = taskGroupName;

                Metadata.CustomMetadataValue taskField = new Metadata.CustomMetadataValue();

                taskField.field = 'Task__c';
                taskField.value = selectedTaskName;
                
                Metadata.CustomMetadataValue orderField = new Metadata.CustomMetadataValue();

                orderField.field = 'Order__c';
                orderField.value = count;
                
                customMetadata.values.add(groupField);
                customMetadata.values.add(taskField);
                customMetadata.values.add(orderField);
                
                count++; 
                
                mdContainer.addMetadata(customMetadata);
            }

            Peak_CustomMetadataCallback callback = new Peak_CustomMetadataCallback();

            // Enqueue custom metadata deployment
            // jobId is the deployment ID
            
            if(count > 1){
                Id jobId;
                if(!test.isRunningTest()) {
                    jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
                }
                peakResponse.messages.add(jobId);
            }
            else{
                peakResponse.success = false;
                peakResponse.messages.add('Nothing to Save');
            }        

            //peakResponse.results.add(checklist);
        } catch (exception e) {
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }
        // Return result and possible error messages
        return peakResponse;
    }

    //  A new method to query Peak Metadata Deploy Result by ID
    @AuraEnabled
    public static Peak_Response getDeployGroupResult(String jobId){

        Peak_Response peakResponse = new Peak_Response();
        try{
            peakResponse.results = [Select Success__c, Detailed_Message__c from Peak_Metadata_Deploy_Result__c where Job_ID__c = :jobId];
        } catch (Exception e){
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }
        return peakResponse;
    }

    public static Metadata.CustomMetadataValue deactivateField(set<String> setTaskNamesToDeactivate, String selectedTaskName){
        Metadata.CustomMetadataValue deactivateField = new Metadata.CustomMetadataValue();
        deactivateField.field = 'Deactivate__c';

        //setting Deactivate__c field to true
        if(setTaskNamesToDeactivate.contains(selectedTaskName)){
            deactivateField.value = true;
        }
        else
        {
            deactivateField.value = false;
        }
        return deactivateField;
    }

}