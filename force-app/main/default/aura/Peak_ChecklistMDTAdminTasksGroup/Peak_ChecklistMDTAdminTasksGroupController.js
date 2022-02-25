/**
 * Created by shashi arrabeli on 4/18/18.
 */
({
    createTaskGroupMDT : function(component, event,helper) {
        component.set("v.isLoading",true);
        var newTaskGroupName = component.get("v.newTaskGroupName");
        var params = {
            "newTaskGroupName": newTaskGroupName
        };
        helper.doCallout(component,"c.saveTaskGroup",params).then($A.getCallback(function(response){

            // No major errors, but technically the deployment could still be invalid
            if (response.success) {

                //Get refresh event and pass into pollForDeployment
                var appEvent = $A.get('e.c:Peak_CheckListRefreshEvent');

                // Call the pollForDeploymentResults method
                var jobId = response.messages[0];
                helper.pollForDeploymentTaskGroupResults(component, event,helper,jobId,"c.getDeployGroupResult","v.newTaskGroupName", appEvent, 'Task Group Saved Successfully');

            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        }));

    },
    doChecklistAdminTaskGroupsInit : function(component, event, helper)
    {

        helper.getTaskGroups(component,event,helper);
    },

    deleteSelectedTaskGroup : function(component, event, helper){
        var taskGroupName = event.target.dataset.name;
        var taskGroupLabel = event.target.dataset.label;
        component.set("v.isLoading",true);

        var params = {
            "taskGroupName": taskGroupName,
            "taskGroupLabel" : taskGroupLabel
        };

        helper.doCallout(component,"c.deleteTaskGroup",params).then($A.getCallback(function(response){

            // No major errors, but technically the deployment could still be invalid
            if (response.success) {

                //Get refresh event and pass into pollForDeployment
                var appEvent = $A.get('e.c:Peak_CheckListRefreshEvent');

                // Call the pollForDeactivationGroupResults method
                var jobId = response.messages[0];
                helper.pollForDeactivationGroupResults(component, event,helper,jobId,"c.getDeployGroupResult",taskGroupLabel+ ' Deactivated Successfully', appEvent);


            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        }));
    }


})