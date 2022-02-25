({
    doChecklistAdminInit : function(component, event, helper) {
        helper.doCallout(component,"c.getTasks",null).then(function(response){
            component.set("v.listOfTasks",response);
        });
        helper.doCallout(component,"c.getTaskGroups",null).then(function(response){
            component.set("v.listOfTaskGroups",response);
        });

    },
    doTaskAssignment : function(component, event, helper){
        var _userId = component.find("userLookUpId").get("v.value");
        if(_userId == null || _userId == ''){
            helper.showMessage('Error',$A.get("$Label.c.Peak_Select_a_User"));
            return false;
        } else {
            var _tasks = component.get('v.listOfTasks');
            var _taskGroups = component.get('v.listOfTaskGroups');
            helper.createTasksFromFormForUser(component, helper,_userId, _tasks, _taskGroups);
        }
    }
})