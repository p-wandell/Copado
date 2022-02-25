// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
		helper.getSitePrefix(component);
		helper.isNicknameDisplayEnabled(component);
		helper.checkCreate(component);
		helper.getFeaturedNews(component);
	},

    gotoAllNewsUrl: function(component, event, helper) {
        helper.gotoUrl(component, component.get('v.allNewsUrl'));
    },

    gotoCreateNewsUrl: function(component, event, helper) {
        helper.gotoUrl(component, component.get('v.createNewsURL'));
    }
})