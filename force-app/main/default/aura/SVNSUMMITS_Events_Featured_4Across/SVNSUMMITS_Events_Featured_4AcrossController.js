// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getFeaturedFourEvents : function(component, event, helper) {
    	helper.getSitePrefix(component);
    	helper.isObjectCreatable(component);
	    helper.fetchFeaturedFourEvents(component, event);
    },

	gotoAllEvents: function (component, event, helper) {
		helper.gotoUrl(component, component.get('v.allEventsUrl'));
	},

	gotoAddEvent: function (component, event, helper) {
		helper.gotoUrl(component, component.get('v.addNewEventUrl'));
	}
})