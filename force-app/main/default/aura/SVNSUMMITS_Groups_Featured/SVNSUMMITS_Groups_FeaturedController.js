// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    //Method called after scripts loaded
	doInit : function(component, event, helper) {
        helper.getFeaturedGroups(component);
        helper.isNicknameDisplayEnabled(component);
	},

    goToAllGroups: function(component, event, helper) {
        let urlEvent = $A.get("e.force:navigateToURL");
        let allGroupsUrl = component.get("v.allGroupsUrl");
        urlEvent.setParams({
            "url": allGroupsUrl
        });
        urlEvent.fire();
    }
});