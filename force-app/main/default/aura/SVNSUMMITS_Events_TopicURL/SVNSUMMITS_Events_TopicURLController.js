// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.FetchTopicUrl(component);
	},

	navigateToTopic: function (component, event, helper) {
		var topicId = component.get("v.topicId");

		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": topicId,
				"slideDevName": "related"
			}).fire();
	}
})