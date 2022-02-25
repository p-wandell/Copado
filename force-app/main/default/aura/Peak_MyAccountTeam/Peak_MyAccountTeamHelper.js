({
    getAccountTeam : function(component, event, helper) {

        helper.doCallout(component,"c.getAccountTeam",{}).then(function(response){
            console.log(response);
            component.set("v.peakResponse",response); // rather than showMessage, we will just display message inline for this component
        });
    },

    gotoURL : function (cmp, userId) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/profile/" + userId
        });
        urlEvent.fire();
    }
});