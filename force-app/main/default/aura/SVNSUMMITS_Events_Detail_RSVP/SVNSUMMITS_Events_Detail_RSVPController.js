// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.getEventRecord(component);
		helper.getRSVPMember(component);
	},

	handleAttendClick: function (component, event, helper) {
		var attending = component.get('v.isPresentRSVP');

		// toggle attendance
		if (attending) {
			helper.deleteRsvp(component);
		}
		else {
			helper.createRsvp(component);
		}
	}
})