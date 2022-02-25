// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	FetchTopicUrl: function (component) {
		var topicNameToIdMap = component.get("v.topicNameToId");
		var topicName = component.get("v.topicName");
		var topicId = topicNameToIdMap[topicName];
		component.set('v.topicId', topicId);
	}
})