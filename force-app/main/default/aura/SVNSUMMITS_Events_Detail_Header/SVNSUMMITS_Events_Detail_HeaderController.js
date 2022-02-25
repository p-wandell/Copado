// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
        helper.debug(component,"Header Called",null);

        var action = component.get("c.getEventName");

        action.setParams({
            eventRecordId: component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var eventName= response.getReturnValue();
            component.set("v.eventName", eventName);
        });

        $A.enqueueAction(action);
    },

    gotoEventList : function (component, event, helper) {
    	var url = component.get('v.exploreOtherEventsURL');
    	if (url[0] !== '/') {
    		url = '/' + url;
	    }

        helper.gotoUrl(component, url);
    }
})