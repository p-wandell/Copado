/**
 * Created by shashi arrabeli on 4/12/18.
 */
({
    createTaskMDT : function(component, event,helper) {
        component.set("v.isLoading",true);
        var newTaskName = component.get("v.newTaskName");
        var params = {
            "newTaskName": newTaskName
        };
        helper.doCallout(component,"c.saveTask",params).then($A.getCallback(function(response){

            // No major errors, but technically the deployment could still be invalid
            if (response.success) {

                //Get refresh event and pass into pollForDeployment
                var appEvent = $A.get('e.c:Peak_CheckListRefreshEvent');

                //Call the pollForDeploymentResults method
                var jobId = response.messages[0];
                helper.pollForDeploymentResults(component, event,helper,jobId,"c.getDeployResult","v.newTaskName", appEvent, ' Task Saved Successfully');

            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        }));


    },
    doChecklistAdminTasksInit : function(component, event, helper)
    {
        helper.getTasks(component,event,helper);
    },
    
    deleteSelectedTask : function(component, event, helper){
        var taskName = event.target.dataset.name;
        var taskLabel = event.target.dataset.label;
        component.set("v.isLoading",true);
        
        var params = {
            "taskName": taskName,
            "taskLabel" : taskLabel
        };
        
        helper.doCallout(component,"c.deleteTask",params).then($A.getCallback(function(response){

            // No major errors, but technically the deployment could still be invalid
            if (response.success) {

                //Get refresh event and pass into pollForDeactivation
                var appEvent = $A.get('e.c:Peak_CheckListRefreshEvent');

                //Call the pollForDeactivationResults method
                var jobId = response.messages[0];
                helper.pollForDeactivationResults(component, event,helper,jobId,"c.getDeployResult",taskLabel+ ' Deactivated Successfully', appEvent);

            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        }));
    }

})