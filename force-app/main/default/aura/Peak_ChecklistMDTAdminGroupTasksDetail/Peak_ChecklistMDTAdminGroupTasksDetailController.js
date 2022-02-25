({//Loads all the tasks, groups and group assignments on the component initiation
	doInit : function(component, event, helper) {
        helper.getTaskGroups(component,event,helper);
		helper.getTasks(component,event,helper);
        helper.getTaskGroupAssignments(component,event,helper);
	},
    //Creating tasklist for dualList box
    createTaskBox : function(component, event, helper){
    	var listOfTasks = component.get("v.listOfTasks");
        var options = [];
        listOfTasks.forEach(function(task)  { 
            options.push({ value: task.name, label: task.label});
        });
        component.set("v.listTaskOptions", options);
	},
    //Selecting first taskGroup on component Load
    setDefaultGroup : function(component, event, helper){
        var listOfTaskGroups = component.get("v.listOfTaskGroups");
        if(listOfTaskGroups.length > 0){
            component.set("v.selectedTaskGroupId", listOfTaskGroups[0].id);
        }
    },
    //This function fetches all the tasks previously assigned for the group that has been selected. If nothing selected it displays empty tasks in selected pane.
    handleGroupChange : function(component, event, helper){
        var listOfTaskGroupAssignments = component.get("v.listOfTaskGroupAssignments");
        var selectedTaskGroup = component.get("v.selectedTaskGroup");
        var listOfTaskGroups =  component.get("v.listOfTaskGroups");
        
        listOfTaskGroups.forEach(function(group)  {
            if(group.name == selectedTaskGroup){
                selectedTaskGroup = group.id;
            }
                
        });
        
        if(selectedTaskGroup != null && selectedTaskGroup != "" && selectedTaskGroup != undefined){
            var options = [];
            listOfTaskGroupAssignments.forEach(function(groupAssignment)  {
                if(groupAssignment.Group__c == selectedTaskGroup){
                    var listOfTasks = component.get("v.listOfTasks");
                    listOfTasks.forEach(function(task)  {
                        if(task.id == groupAssignment.Task__c)
                        	options.push(task.name);
                    });
                }
            });
            component.set("v.selectedTaskOptions", options);
        }
    },
    
    //This function saves the selected taskgroup assignments
    saveTaskGroupAssignment : function(component, event, helper){
        var selectedTaskGroup = component.get("v.selectedTaskGroup");
        var selectedTaskOptions =  component.get("v.selectedTaskOptions");
        
        component.set("v.isLoading",true);

        var params = {
            "taskGroupName": selectedTaskGroup,
            "selectedTaskNames" : selectedTaskOptions
        };

        helper.doCallout(component,"c.saveTaskGroupAssignments",params).then(function(response){

            // No major errors, but technically the deployment could still be invalid
            if (response.success) {
                // Call the pollForDeactivationGroupResults method

                var jobId = response.messages[0];

                helper.pollForDeploymentTaskGroupAssignmentResults(component, event,helper,jobId,"c.getDeployGroupResult", "Selected Tasks Assigned to the Group");
            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        });
    },

    //Handler for Peak_ChecklistRefreshEvent which will get the updated list of tasks
    handleRefreshEvent : function(component, event, helper){
        helper.getTasks(component,event,helper);
        helper.getTaskGroups(component,event,helper);
    }
})