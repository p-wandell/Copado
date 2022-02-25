// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	canCreateEvent: function(component) {
		var action = component.get("c.isObjectCreatable");
		
		action.setCallback(this, function (actionResult1) {
			var isObjectCreatable = actionResult1.getReturnValue();
			component.set("v.isObjectCreatable", isObjectCreatable);
		});

		$A.enqueueAction(action);
	},

	showSpinner: function (component) {
		var spinner = component.find("spinner");
		$A.util.removeClass(spinner, 'slds-hide');
	},

	hideSpinner: function (component) {
		var spinner = component.find("spinner");
		$A.util.addClass(spinner, 'slds-hide');
	}
})