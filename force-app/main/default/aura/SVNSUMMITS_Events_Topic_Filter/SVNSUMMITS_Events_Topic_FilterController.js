// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	//Initialization Method
	doInit: function (component, event, helper) {
		helper.getTopics(component);
	},

	setTopic: function (component, event, helper) {
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_Topic_Filter_Event");

		if (component.find("filterByTopic").get("v.value") === '') {
			var cmpTarget = component.find('clearButton');
			$A.util.removeClass(cmpTarget, 'toggleClass1');
			$A.util.addClass(cmpTarget, 'toggleClass');
			appEvent.setParams({
				"filterByTopic": null
			});
		} else {
			appEvent.setParams({
				"filterByTopic": component.find("filterByTopic").get("v.value"),
			});
		}
		appEvent.fire();
	}
})