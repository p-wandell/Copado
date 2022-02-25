// Copyright ©2016-2017 7Summits Inc. All rights reserved.

/**
 * Created by francoiskorb on 6/5/17.
 */
({
	doInit: function(component, event, helper) {
		helper.doCallout(component, "c.getModel", {}, false, 'Get namespace').then(
			function(response) {
				component.set("v.baseModel", JSON.stringify(response));
				component.getEvent("baseReady").fire();
				svg4everybody();
			}
		);
	}
});