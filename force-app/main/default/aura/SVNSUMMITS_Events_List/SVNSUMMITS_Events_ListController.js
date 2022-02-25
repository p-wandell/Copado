// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	//Initialize method for list view component
	doInit: function (component, event, helper) {

		if (helper.viewStateIsCalendar()) {
			component.set('v.listViewMode', 'Calendar');
		}

		let listViewMode = component.get("v.listViewMode");
		helper.debug(component, 'List Component init - ' + listViewMode);

		$A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event")
			.setParams({listViewMode: listViewMode})
			.fire();

		let url      = window.location.href;
		let urlParts = url.split(/[\/?]/);
		let start    = 0;

		for (; start < urlParts.length; start++) {
			if (urlParts[start] === 's') {
				break;
			}
		}

		component.set("v.currentURL", encodeURIComponent(url));

		let recordId    = component.get('v.recordId');
		let urlTarget   = urlParts[start + 1];
		let filterValue = urlParts[start + 2];
		let filterName  = urlParts[start + 3];

		let filterOn = component.get("v.filterOn");

		if (filterOn === "Search Term") {
			component.set("v.searchstr", filterValue);
		}
		else if (filterOn === "Topic Value") {
			component.set("v.topicValue", filterName);
		}
		else if (filterOn === "Group") {
			component.set("v.topicValue", filterValue);
		}
		else if (filterOn.indexOf('My Events') !== -1) {
			// regular filter should handle this
			// -- add userId only once
			if (filterOn.indexOf(':') === -1
				&& urlTarget === 'profile'
				&& recordId) {
				component.set('v.filterOn', filterOn + ':' + recordId);
			}
		}

		let filterByTopic = component.get('v.filterEventsByTopic');
		if (filterByTopic)
		{
			component.set("v.filterByTopic", filterByTopic);
		}

		if (!component.get('v.init') && listViewMode !== 'Calendar') {
			helper.persistListView();
			helper.getSitePrefix(component);
			helper.getEventsHelper(component);
		}

		component.set("v.init", true);
	},

	//Get Next method for next page and pagination
	getNextPage: function (component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		component.set("v.wrappedEvents.objEventList", null);
		helper.getNextPage(component, event);
	},

	//Get Previous method for Previous page and pagination
	getPreviousPage: function (component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		component.set("v.wrappedEvents.objEventList", null);
		helper.getPreviousPage(component, event);
	},

	setDateFilter: function (component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		let fromDate = event.getParam("fromDate");
		let toDate   = event.getParam("toDate");

		component.set("v.fromDate", fromDate);
		component.set("v.toDate", toDate);

		helper.getEventsHelper(component);
	},

	setTopicFilter: function (component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		let filterByTopic = event.getParam("filterByTopic");

		component.set("v.filterByTopic", filterByTopic);

		helper.getEventsHelper(component);
	},

	setLocationFilter : function (component, event,helper) {
		if (!component.get("v.init")) {
			return;
		}
		component.set('v.locationFilter', event.getParam('filterValue'));
		helper.getEventsHelper(component);
	},

	setTypeFilter: function(component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		component.set('v.eventTypeFilter', event.getParam('filterValue'));
		helper.getEventsHelper(component);
	},

	setCustomFilter: function(component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}
		component.set('v.customFilter', event.getParam('filterString'));
		helper.getEventsHelper(component);
	},

	// Sort By lists method
	setSortBy: function (component, event, helper) {
		if (!component.get("v.init")) {
			return;
		}

		component.set("v.sortBy",      event.getParam("sortBy"));
		component.set("v.sortByLabel", event.getParam('sortByLabel'));

		if (component.get('v.listViewMode') !== 'Calendar') {
			helper.getEventsHelper(component, event);
		}
	},

	setDisplayMode: function(component, event, helper) {
		let listViewMode = event.getParam("listViewMode");

		component.set("v.listViewMode", listViewMode);
		helper.saveViewState(listViewMode);
		event.stopPropagation();
	},

	gotoEventList : function (component, event, helper) {
		let url = component.get('v.listViewPageUrl');
		if (url[0] !== '/') {
			url = '/' + url;
		}

		helper.gotoUrl(component, url);
	}
});