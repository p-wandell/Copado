// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	afterRender: function (component, helper) {
		this.superAfterRender();
		var display = component.get('v.displayMode');
		//console.log("displayMode = " + display);

		if (display == 'List') {
			window.setTimeout($A.getCallback(function () {
				helper.topicsCheck(component);
			}), 3000);
		}
	}

})