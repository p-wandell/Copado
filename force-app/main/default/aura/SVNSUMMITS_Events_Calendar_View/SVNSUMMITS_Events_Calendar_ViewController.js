// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	//Initialize the calendar method
	doInit: function (component, event, helper) {
		helper.debug(component, 'Calendar Component init');

		// // tell the app we are in calendar mode
		$A.get('e.c:SVNSUMMITS_Events_DisplayMode_Event')
			.setParams(
				{
					sortBy: component.get('v.sortBy'),
					listViewMode: 'Calendar'
				})
			.fire();

		helper.persistCalendarView();

		helper.doCallout(component, 'c.getSitePrefix', {}, true, '').then(
			sitePath => {
				let position = sitePath.lastIndexOf('/s');
				component.set('v.sitePrefix', sitePath.substring(0, position));

				helper.initializeCalendarJQ(component);
				helper.calendarGotoDate(component, helper.retieveCalendarDate() || moment());
				helper.clearCaledarDate();
			}
		);
	},

	updateHeader: function (component, event, helper) {
		$A.get('e.c:SVNSUMMITS_Events_Header_Event')
			.setParams(
				{
					sortByLabel: component.get('v.sortByLabel'),
					totalResults: component.get('v.totalResults')
				}
			).fire();
	},

	//Sort by methods for Calendar view
	sortBy: function (component, event, helper) {
		component.set('v.sortBy', event.getParam('sortBy'));
		helper.calendarRefetchEvents(component);
	},

	setDateFilter: function (component, event, helper) {
		let fromDate = event.getParam('fromDate');
		helper.calendarGotoDate(component, fromDate ? moment(fromDate) : moment());
	},

	setTopicFilter: function (component, event, helper) {
		component.set("v.filterByTopic", event.getParam("filterByTopic"));
		helper.calendarRefetchEvents(component);
	},

	setLocationFilter: function (component, event, helper) {
		component.set('v.locationFilter', event.getParam('filterValue'));
		helper.calendarRefetchEvents(component);
	},

	setTypeFilter: function (component, event, helper) {
		component.set('v.eventTypeFilter', event.getParam('filterValue'));
		helper.calendarRefetchEvents(component);
	},

	setCustomFilter: function (component, event, helper) {
		component.set('v.customFilter', event.getParam('filterString'));
		helper.calendarRefetchEvents(component);
	}
});