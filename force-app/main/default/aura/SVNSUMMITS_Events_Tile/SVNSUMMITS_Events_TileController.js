// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	goToRecordDetail: function (component, event, helper) {
		$A.get("e.force:navigateToURL")
			.setParams({
				"url": $(event.currentTarget).data("id"),

			})
			.fire();
	},

	goToRecord : function(component, event, helper){
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": $(event.currentTarget).data("id"),
				"slideDevName": "related"})
			.fire();
	}
})