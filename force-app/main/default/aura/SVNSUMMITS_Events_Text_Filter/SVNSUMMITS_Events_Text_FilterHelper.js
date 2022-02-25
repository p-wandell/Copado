// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	sendFilterEvent: function (component) {
		var searchText = component.get("v.searchText");

		if (searchText === undefined) {
			searchText = '';
		}

		$A.get("e.c:SVNSUMMITS_Events_Text_Filter_Event")
			.setParams({
				"searchText": searchText
			})
			.fire();
	}
})