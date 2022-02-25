({
    doChecklistsInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");

        var params = {
            "userIdString" : userId
        };
        helper.doCallout(component,"c.getChecklistForUser",params).then(function(response){
            if (response.success) {
                component.set("v.peakResponse",response);
            }else{
                helper.showMessage('Error',response.messages[0]);
            }
        });
    }
})