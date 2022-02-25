// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.getSitePrefix(component);
		helper.getEventRecord(component, event, helper);
		helper.isRecordEditable(component);
	},

	callEditPage: function (component, event, helper) {
		helper.initializeEventPageEdit(component, event);
	},

	closeEdit: function (component, event, helper) {
		component.set('v.isEdit', false);
	},

    callVolunteerPage: function (component, event, helper) {
        component.set('v.isEditVolunteers', true);
        helper.initializeVolunteerForm(component, event);
    },

    closeVolunteerPage: function (component, event, helper) {
        component.set('v.isEditVolunteers', false);
    },

	gotoURL: function (component, event, helper) {
		var payment = component.find("payment").get("v.value");
		var urlEvent = $A.get("e.force:navigateToURL");

		urlEvent.setParams({
			"url": payment
		});
		urlEvent.fire();
	},

	gotoGroup: function (component, event, helper) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": $(event.currentTarget).data("id"),
				"slideDevName": "related"
			})
			.fire();
	},

	//calling method in helper for updating
	//add to calendar button name as per provided by user in properties
	updateATCbuttonName: function (component, event, helper) {
		helper.updateATCbuttonName(component);
	},

	// Have to use a timer to allow the values to be set before being read by add-to-calendar
	detailLoaded: function (component, event, helper) {
		window.setTimeout($A.getCallback(function() {
			if (!component.get('v.hideAddToCalendar')) {
				var selectedCalendars = [];

				for (var i = 0; i < helper.details.calendars.length; i++) {
					if (component.get(helper.details.calendars[i].name)) {
						selectedCalendars.push(helper.details.calendars[i].value);
					}
				}

				var atc = component.find('atc_span');
				atc.getElement().dataset.calendars = selectedCalendars.join(',');
			}

			addtocalendar.load();
		}), 1000);

		component.set('v.init', true);
	}
});