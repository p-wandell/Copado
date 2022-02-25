// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.canCreateEvent(component);

		// set the view layout button state
		component.set('v.listViewState', component.get('v.defaultView') === 'List');

		let appEvent = $A.get("e.c:SVNSUMMITS_Events_SortBy_Filter_Event");

		appEvent.setParams({
			sortBy:       component.get("v.sortBy"),
			listViewMode: component.get("v.defaultView"),
			sortByLabel:  component.get("v.sortByLabel")
		});

		appEvent.fire();
	},

	setHeaderValues: function (component, event, helper) {
		let totalResults = event.getParam("totalResults");
		component.set("v.numberOfResults", totalResults);

		let sortByLabel = event.getParam("sortByLabel");

		if (sortByLabel) {
			component.set("v.sortByLabel", sortByLabel);
		}

		helper.hideSpinner(component);
	},

	setParameters: function (component, event, helper) {
		let appEvent = $A.get("e.c:SVNSUMMITS_Events_SortBy_Filter_Event");

		appEvent.setParams({
			sortBy: component.get("v.sortBy"),
			listViewMode: component.get("v.defaultView"),
			sortByLabel: component.get("v.sortByLabel")
		});

		appEvent.fire();
	},

	gotoUrl: function (component, event, helper) {
		let createUrl = component.get('v.createButtonURL');
		helper.gotoUrl(component, createUrl);
	},

	onSortChange: function (component, event, helper) {
		helper.showSpinner(component);

		// get the current selection
		let selection = event.target.value;

		component.set('v.sortBy', selection);
		component.set('v.sortByLabel', selection === 'Upcoming' ?
			$A.get('$Label.c.ss_label_Upcoming') : $A.get('$Label.c.ss_label_TopAttendance'));

		let appEvent = $A.get("e.c:SVNSUMMITS_Events_SortBy_Filter_Event");

		appEvent.setParams({
			sortBy: selection,
			sortByLabel: component.get('v.sortByLabel'),
			listViewMode: component.get("v.listViewMode")
		});

		appEvent.fire();
	},

	setListView: function (component, event, helper) {
		helper.showSpinner(component);

		// set the view layout button state
		component.set('v.listViewState', true);

		$A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event")
			.setParams({listViewMode: 'List'})
			.fire();

	},

	setCalendarView: function (component, event, helper) {
		helper.showSpinner(component);

		// set the view layout button state
		component.set('v.listViewState', false);

		$A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event")
			.setParams({listViewMode: 'Calendar'})
			.fire();
	},

	setDisplayMode: function (component, event, helper) {
		let listViewMode = event.getParam("listViewMode");
		component.set("v.listViewMode", listViewMode);
		component.set('v.listViewState', listViewMode === 'List');
	}
});