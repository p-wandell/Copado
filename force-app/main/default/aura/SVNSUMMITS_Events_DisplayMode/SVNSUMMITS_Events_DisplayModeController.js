// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setParameters: function (component, event, helper) {
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event");
		appEvent.setParams({
			"listViewMode": component.get("v.listViewMode")
		});
		appEvent.fire();
	},

	setListView: function (component, event, helper) {
		var cmpTargetSortBy = component.find('sortDiv');
		$A.util.removeClass(cmpTargetSortBy, 'hideImg');
		$A.util.addClass(cmpTargetSortBy, 'showImg');

// TODO - THIS SEEMS LIKE A HACK. SHOULD BE FIRING AN EVENT THAT COMPONENT LISTENS ON
// TODO - Also need to show the sort by widget?
		$('.CCEVENTSLCSVNSUMMITS_Events_Date_Filter').show();

		helper.setListButtonActive(component);
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event");
		appEvent.setParams({
			"listViewMode": "List"
		});
		appEvent.fire();
	},

	setTileView: function (component, event, helper) {
		var cmpTargetSortBy = component.find('sortDiv');
		$A.util.removeClass(cmpTargetSortBy, 'hideImg');
		$A.util.addClass(cmpTargetSortBy, 'showImg');

// TODO - THIS SEEMS LIKE A HACK. SHOULD BE FIRING AN EVENT THAT COMPONENT LISTENS ON
// TODO - Also need to show the sort by widget?
		$('.CCEVENTSLCSVNSUMMITS_Events_Date_Filter').show();

		helper.setTileButtonActive(component);
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event");
		appEvent.setParams({
			"listViewMode": "Tile"
		});
		appEvent.fire();
	},

	setCalendarView: function (component, event, helper) {
		var cmpTarget1 = component.find('sortDiv');
		$A.util.removeClass(cmpTarget1, 'showImg');
		$A.util.addClass(cmpTarget1, 'hideImg');

// TODO - THIS SEEMS LIKE A HACK. SHOULD BE FIRING AN EVENT THAT COMPONENT LISTENS ON
// TODO - Also need to hide the sort by widget?
		$('.CCEVENTSLCSVNSUMMITS_Events_Date_Filter').hide();

		helper.setCalendarButtonActive(component);
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_DisplayMode_Event");

		appEvent.setParams({
			"listViewMode": "Calendar"
		});
		appEvent.fire();

	},

	setDisplayMode: function (component, event, helper) {
		var listViewMode = event.getParam("listViewMode");
		component.set("v.listViewMode", listViewMode);
// TODO - THIS NEEDS TO INITIALIZE THE STYLES ON THE BUTTONS
	}
})