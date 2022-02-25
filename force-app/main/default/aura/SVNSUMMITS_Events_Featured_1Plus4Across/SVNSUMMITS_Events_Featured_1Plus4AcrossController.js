// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getFeaturedFourEvents : function(component, event, helper) {
        helper.fetchFeaturedFourEvents(component, event);
        helper.get_SitePrefix(component);
        helper.debug(component,"Helper Called",null);
	}
})