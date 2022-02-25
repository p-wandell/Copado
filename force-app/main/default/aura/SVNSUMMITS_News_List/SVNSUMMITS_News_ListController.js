// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.debug(component, "List controller - doInit");
		// url format
		//      force.com/s/topic/id/name/...
		// or
		//      force.com/s/group/id/name/...
		// parameters start after /s/
		const url = window.location.href;
		component.set("v.currentURL", encodeURIComponent(url));

		let urlParts = url.split(/[\/?]/);
		let start = 0;

		for(; start < urlParts.length; start++) {
			if (urlParts[start] === 's') {
				break;
			}
		}

		let filterOn = component.get("v.filterOn");
		if (filterOn === "Search Term") {
			component.set("v.searchstr", component.get("v.filterId"));
		}
		else if (filterOn === "Topic Value") {
			// Topic uses the topic name
			component.set("v.topicName", urlParts[start + 2]);
		}
		else if (filterOn === "Group") {
			// Group uses the ID
			let groupId = urlParts[start + 2];
			component.set("v.groupID", groupId);
		}
		else {
			component.set("v.filterId", component.get("v.recordId"));
		}

		// check to see if the user set a default topic filter
		let filterNewsListByTopic = component.get("v.filterNewsListByTopic");
		if (filterNewsListByTopic !== undefined && filterNewsListByTopic !== '') {
			component.set("v.filterByTopic", filterNewsListByTopic);
		}

		helper.getNewsList(component, event);
		helper.get_SitePrefix(component);
		helper.isNicknameDisplayEnabled(component);
		//helper.sortByShowHide(component);
	},

	//Changed due to resolve the java script Error of Renderer/afterRender
	// so that added afterScriptsLoaded to call sortByShowHide() method
	afterScriptsLoaded: function (component, event, helper) {
		helper.sortByShowHide(component);
	},

	gotoList: function(component, event, helper) {
		helper.gotoUrl(component, component.get('v.newsListURL'));
	},

	setSortBy: function (component, event, helper) {
		const sortBy = event.getParam("sortBy");
		component.set("v.sortBy", sortBy);
		helper.getNewsList(component, event);

	},

	setDates: function (component, event, helper) {
		const fromDate = event.getParam("fromDate");
		const toDate = event.getParam("toDate");
		component.set("v.fromDate", fromDate);
		component.set("v.toDate", toDate);

		helper.getNewsList(component, event);
	},

	setTopic: function (component, event, helper) {
		const filterByTopic = event.getParam("filterByTopic");
		component.set("v.filterByTopic", filterByTopic);
		helper.getNewsList(component, event);
	},

	setAuthor: function (component, event, helper) {
		const filterByAuthor = event.getParam("filterByAuthor");
		component.set("v.filterByAuthor", filterByAuthor);
		helper.getNewsList(component, event);
	},

	setSearchText: function (component, event, helper) {
		const searchText = event.getParam("searchText");
		component.set("v.searchstr", searchText);
		helper.getNewsList(component, event);
	},

	getNextPage: function (component, event, helper) {
		component.set("v.newsListWrapper.newsList", null);
		helper.getNextPage(component);
	},

	getPreviousPage: function (component, event, helper) {
		component.set("v.newsListWrapper.newsList", null);
		helper.getPreviousPage(component);
	},

	setDisplayMode: function (component, event, helper) {
		const listViewModeGet = event.getParam("listViewMode");

		if (listViewModeGet === "Tile") {
			component.set("v.listViewMode", "List");
			component.set("v.displayMode", "Tile");
		} else if (listViewModeGet === "List") {
			component.set("v.listViewMode", "List");
			component.set("v.displayMode", "List");
		} else {
			component.set("v.listViewMode", listViewModeGet);
		}
	}
});