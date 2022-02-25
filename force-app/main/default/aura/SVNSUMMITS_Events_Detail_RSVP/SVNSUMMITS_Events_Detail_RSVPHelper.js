// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getEventRecord: function (component) {
		var action = component.get("c.getEventRecord");

		action.setParams({
			eventRecordId: component.get("v.recordId"),
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var eventsListWrapper = this.parseNamespace(component, response.getReturnValue());

				for (var i = 0; i < eventsListWrapper.objEventList.length; i++) {
					var endDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c);

					if (endDate) {
						if (endDate.isBefore(moment({}))) {
							component.set("v.passedEvent", false);
						}
					}
				}

				component.set('v.attendeeCount', eventsListWrapper.objEventList[0].Number_of_Attendees__c);
				component.set("v.wrappedEventsObj", eventsListWrapper);
			}
		});
		$A.enqueueAction(action);

		var action2 = component.get("c.checkRSVPevents");
		action2.setParams({
			EventId: component.get('v.recordId')
		});

		action2.setCallback(this, function (response) {
			component.set('v.isPresentRSVP', response.getReturnValue());
		});
		$A.enqueueAction(action2);
	},

	createRsvp: function(component) {
		var action = component.get("c.createRSVPevents");

		action.setParams({
			EventName: component.get('v.recordId'),
			response: 'Yes'
		});
		$A.enqueueAction(action);

		this.getRSVPMember(component);
	},

	deleteRsvp: function (component) {
		var action = component.get("c.deleteRSVPevents");

		action.setParams({
			EventId: component.get('v.recordId')
		});
		$A.enqueueAction(action);

		this.getRSVPMember(component);
	},

    getRSVPMember : function(component) {
		var self = this;
    	var action = component.get("c.getRSVPMemberAttendes");

    	action.setParams({
            EventName: component.get("v.recordId")
        });

    	action.setCallback(this, function(actionResult) {
            var isYesEnable = actionResult.getReturnValue();
		    component.set("v.isPresentRSVP", isYesEnable);

		    self.getRsvpCount(component);
	    });

        $A.enqueueAction(action);
	},

	getRsvpCount: function (component) {
		var action = component.get('c.getRSVPAttendeeCount');

		action.setParams({
			eventId: component.get("v.recordId")
		});

		action.setCallback(this, function(actionResult) {
			var state = actionResult.getState();

			if (component.isValid() && state === "SUCCESS") {
				component.set('v.attendeeCount', actionResult.getReturnValue());
			}
		});

		$A.enqueueAction(action);

	},


    debug: function(component, msg, variable) {
        var debugMode = component.get("v.debugMode");

        if(debugMode) {
            if (msg) {
            	console.log(msg);
            }
            if (variable) {
            	console.log(variable);
            }
        }
    }
})