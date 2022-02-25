({
	updateTask : function(component, task){
		var _params = {
			"task" : task
		};
		this.doCallout(component,"c.updateTask",_params).then(function(response){
            if(!response.success){
                helper.showMessage('Error',response.messages[0]);
            }
		});
	},
    createTasksFromFormForUser : function(component,helper, userId, tasks, taskGroups){
		var _params = {
			"userIdString" : userId,
			"tasksJSONString" : JSON.stringify(tasks),
			"taskGroupsJSONString" : JSON.stringify(taskGroups)
		};
		this.doCallout(component,"c.createTasksFromFormForUser",_params).then(function(response){
            if(response.success){
                helper.showMessage('Success',$A.get("$Label.c.Peak_Task_Creation_Success"));
            } else {
                helper.showMessage('Error',response.messages[0]);
            }
        });
	},
    //This function fetches all the tasks
    getTasks : function(component, event, helper)
    {
        helper.doCallout(component,"c.getTasks",null).then(function(response){
            component.set("v.listOfTasks",response);
        });
    },
    //This function fetches all the taskgroups
    getTaskGroups : function(component, event, helper) {
        helper.doCallout(component, "c.getTaskGroups", null).then(function (response) {
            component.set("v.listOfTaskGroups", response);
        });
    },
    //This function fetches all the tasks group assignments
    getTaskGroupAssignments : function(component, event, helper) {
        helper.doCallout(component, "c.getTaskGroupAssignment", null).then(function (response) {
            component.set("v.listOfTaskGroupAssignments", response);
        });
    },
    //This function does the polling for Tasks
    pollForDeploymentResults:function(component, event, helper, jobId, methodName, inputName, appEvent, successMessage){
        // Setup polling interval to check for deployment result
        var deployResultInterval = setInterval(function(){

            // Try to find the Deploy Result record for this Job ID
            helper.doCallout(component,methodName,{"jobId":jobId}).then($A.getCallback(function(response){
                if(response.success && response.results.length > 0){
                    // Huzzah, we have a result
                    clearInterval(deployResultInterval);

                    // Grab the actual deploy result
                    var deployResult = response.results[0];

                    // Did it work?!?
                    if (deployResult.Success__c){
                        // Show success
                        helper.showMessage('Success',successMessage);

                        // Re-query to reset the list
                        helper.getTasks(component,event,helper);

                        // Reset form
                        component.set(inputName,"");
                    } else {
                        helper.showMessage('Error',deployResult.Detailed_Message__c);
                    }
                    //Fire refresh Event
                    appEvent.fire();
                    component.set("v.isLoading",false);
                }
            }));
        },500);
    },
    //This function does the polling for Task Groups
    pollForDeploymentTaskGroupResults:function(component, event, helper, jobId, methodName, inputName, appEvent, successMessage){
        // Setup polling interval to check for deployment result
        var deployResultInterval = setInterval(function(){

            // Try to find the Deploy Result record for this Job ID
            helper.doCallout(component,methodName,{"jobId":jobId}).then($A.getCallback(function(response){
                if(response.success && response.results.length > 0){
                    // Huzzah, we have a result
                    clearInterval(deployResultInterval);

                    // Grab the actual deploy result
                    var deployResult = response.results[0];

                    // Did it work?!?
                    if (deployResult.Success__c){
                        // Show success
                        helper.showMessage('Success', successMessage);

                        console.log('GOT HERE');

                        // Re-query to reset the list
                        helper.getTaskGroups(component,event,helper);

                        // Reset form
                        component.set(inputName,"");
                    } else {
                        helper.showMessage('Error',deployResult.Detailed_Message__c);
                    }
                    //Fire refresh Event
                    appEvent.fire();
                    component.set("v.isLoading",false);
                }
            }));
        },500);
    },
    //This function does the polling for TaskGroup Assignments
    pollForDeploymentTaskGroupAssignmentResults:function(component, event, helper, jobId, methodName, successMessage){
        // Setup polling interval to check for deployment result
        var deployResultInterval = setInterval(function(){

            // Try to find the Deploy Result record for this Job ID
            helper.doCallout(component,methodName,{"jobId":jobId}).then(function(response){
                if(response.success && response.results.length > 0){
                    // Huzzah, we have a result
                    clearInterval(deployResultInterval);

                    // Grab the actual deploy result
                    var deployResult = response.results[0];

                    // Did it work?!?
                    if (deployResult.Success__c){
                        // Show success
                        helper.showMessage('Success',successMessage);
                        helper.getTaskGroupAssignments(component,event,helper);
                    } else {
                        helper.showMessage('Error',deployResult.Detailed_Message__c);
                    }
                    component.set("v.isLoading",false);
                }
            });
        },500);
    },
    //This function does the polling for Deactivating the Tasks
    pollForDeactivationResults:function(component, event, helper, jobId, methodName, successMessage, appEvent){
        // Setup polling interval to check for deployment result
        var deployResultInterval = setInterval(function(){

            // Try to find the Deploy Result record for this Job ID
            helper.doCallout(component,methodName,{"jobId":jobId}).then($A.getCallback(function(response){
                if(response.success && response.results.length > 0){
                    // Huzzah, we have a result
                    clearInterval(deployResultInterval);

                    // Grab the actual deploy result
                    var deployResult = response.results[0];

                    // Check if it worked?
                    if (deployResult.Success__c){
                        // Show success
                        helper.showMessage('Success',successMessage);

                        // Re-query to reset the list
                        helper.getTasks(component,event,helper);

                    } else {
                        helper.showMessage('Error',deployResult.Detailed_Message__c);
                    }
                    //Fire refresh Event
                    appEvent.fire();
                    component.set("v.isLoading",false);
                }
            }));
        },500);
    },
    //This function does the polling for Deactivating the Task Groups
    pollForDeactivationGroupResults:function(component, event, helper, jobId, methodName, successMessage, appEvent){
        // Setup polling interval to check for deployment result
        var deployResultInterval = setInterval(function(){

            // Try to find the Deploy Result record for this Job ID
            helper.doCallout(component,methodName,{"jobId":jobId}).then($A.getCallback(function(response){
                if(response.success && response.results.length > 0){
                    // Huzzah, we have a result
                    clearInterval(deployResultInterval);

                    // Grab the actual deploy result
                    var deployResult = response.results[0];

                    // Check if it worked?
                    if (deployResult.Success__c){
                        // Show success
                        helper.showMessage('Success',successMessage);

                        // Re-query to reset the list
                        helper.getTaskGroups(component,event,helper);

                    } else {
                        helper.showMessage('Error',deployResult.Detailed_Message__c);
                    }
                    //Fire refresh Event
                    appEvent.fire();
                    component.set("v.isLoading",false);
                }
            }));
        },500);
    }
})