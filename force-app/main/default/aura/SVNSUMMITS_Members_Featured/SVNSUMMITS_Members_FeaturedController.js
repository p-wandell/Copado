/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	doInit : function(component, event, helper) {
        helper.getFeaturedMembers(component);
	},

    gotoAllMembersUrl : function(component, event, helper) {
        helper.gotoUrl(component, component.get('v.allMembersUrl'));
    },

	handleFollowRecord: function (component, event, helper) {
		helper.debug(component, "follow event handled");

		let followAction = event.getParam("follow");
		let followRecord = event.getParam("recordId");

		helper.followRecord(component, followAction, followRecord);
	}
});