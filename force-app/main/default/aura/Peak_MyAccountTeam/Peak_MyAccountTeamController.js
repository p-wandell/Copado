({
    doInit : function(cmp, event, helper) {
        helper.getAccountTeam(cmp, event, helper);
    },

    gotoProfile: function(cmp, event, helper) {
        var userId = event.getSource().get("v.value");
        if(userId) {
            helper.gotoURL(cmp, userId);
        }
    }
});