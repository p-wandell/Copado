// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	// check for the object whether its creatable or not
	getCreatePermission: function (component) {
		let action = component.get("c.isObjectCreatable");

		action.setCallback(this, function (actionResult) {
			let state = actionResult.getState();

			if (state === 'SUCCESS') {
				let isObjectCreatable = actionResult.getReturnValue();
				component.set("v.isObjectCreatable", isObjectCreatable);
			}
		});

		$A.enqueueAction(action);
	},

	// initialize the dropdown in the header section
	initializeDropdown: function (component) {
		try {
			$(".sortingOptions")
				.addClass("ui selection dropdown")
				.dropdown({
					placeholder: "Latest Group Activity"
				});
		} catch (e) {
			this.debug(component, null, e);
		}
	},

	debug: function (component, msg, variable) {
		let debugMode = component.get("v.debugMode");

		if (debugMode) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}

});