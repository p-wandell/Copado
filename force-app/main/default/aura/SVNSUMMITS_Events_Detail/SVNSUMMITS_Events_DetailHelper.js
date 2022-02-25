// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	details : {
		calendars : [
			{name: 'v.iCalendar',       value:'iCalendar'},
			{name: 'v.googleCalendar',  value:'Google Calendar'},
			{name: 'v.outlook',         value:'Outlook'},
			{name: 'v.outlookOnline',   value:'Outlook Online'},
			{name: 'v.yahooCalendar',   value:'Yahoo! Calendar'}
		]
	},

	isRecordEditable: function (component) {
		var eventRecordId = component.get("v.recordId");
		var action = component.get("c.isRecordEditable");
		action.setParams({
			eventRecordId: eventRecordId,
		});

		action.setCallback(this, function (actionResult1) {
			var isEditable = actionResult1.getReturnValue();
			component.set("v.isEditable", isEditable);
		});
		$A.enqueueAction(action);
	},

	getEventRecord: function (component, event, helper) {
		var self = this;
		var eventRecordId = component.get("v.recordId");
		var action = component.get("c.getEventRecord");

		action.setParams({
			eventRecordId: eventRecordId,
			customFields: this.getCustomFields(component)
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var eventsListWrapper = self.parseNamespace(component, response.getReturnValue());

				eventsListWrapper.strTimeZone = self.getTimeZone(eventsListWrapper);

				for (var i = 0; i < eventsListWrapper.objEventList.length; i++) {
					eventsListWrapper.objEventList[i].showTo      = false;
					eventsListWrapper.objEventList[i].showEndDate = false;

					// plain text for ATC Outlook
					eventsListWrapper.objEventList[i].plainText   = self.stripHtml(eventsListWrapper.objEventList[i]['Details__c']);

					// group name
					eventsListWrapper.objEventList[i].groupName = eventsListWrapper.groupIdToName[eventsListWrapper.objEventList[0].GroupId__c];

					var startDate;
					var startTime;
					var endDate;
					var endTime;
					var localeStartDate;
					var localeEndDate;
					var startDay, startMonth, startYear;
					var endDay, endMonth, endYear;

					if (eventsListWrapper.objEventList[i].Start_DateTime__c !== null) {
						localeStartDate = moment.tz(eventsListWrapper.objEventList[i].Start_DateTime__c,
							eventsListWrapper.strTimeZone)
							.format('YYYY-MM-DD HH:mm:ss');

						self.debug(component, "---- Event Detail getEventRecord ----")
						self.debug(component, "Time zone      : " + eventsListWrapper.strTimeZone);
						self.debug(component, "Start Date     : " + eventsListWrapper.objEventList[i].Start_DateTime__c);
						self.debug(component, "localeStartDate: " + localeStartDate);

						eventsListWrapper.objEventList[i].localeStartDate = localeStartDate;

						startDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
						startTime = moment(startDate).toDate();
						eventsListWrapper.objEventList[i].strMinute = moment(startTime);
						var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
						eventsListWrapper.objEventList[i].strDay = days[startTime.getDay()];

						//eventsListWrapper.objEventList[i].Start_DateTime__c = startDate;
					}

					if (eventsListWrapper.objEventList[i].End_DateTime__c !== null) {
						localeEndDate = moment.tz(eventsListWrapper.objEventList[i].End_DateTime__c,
							eventsListWrapper.strTimeZone)
							.format('YYYY-MM-DD HH:mm:ss');

						self.debug(component, "End Date       : " + eventsListWrapper.objEventList[i].End_DateTime__c);
						self.debug(component, "localeEndDate  : " + localeEndDate);

						eventsListWrapper.objEventList[i].localeEndDate = localeEndDate;

						endDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
						endTime = moment(endDate).toDate();
						eventsListWrapper.objEventList[i].strEndMinute = moment(endTime);

						//eventsListWrapper.objEventList[i].End_DateTime__c = endDate;
					}

					if (startTime !== null && endTime !== null) {
						var diffDays = moment.duration((moment(endTime) - moment(startTime)), days).days();
						eventsListWrapper.objEventList[i].daysOfMultiDaysEvent = diffDays;
						eventsListWrapper.objEventList[i].showTo = true;
					}

					startDay = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("DD");
					startMonth = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("MMM");
					startYear = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("YYYY");

					endDay = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("DD");
					endMonth = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("MMM");
					endYear = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("YYYY");

					eventsListWrapper.objEventList[i].strMonth = startMonth;
					eventsListWrapper.objEventList[i].intDate = startDay;
					eventsListWrapper.objEventList[i].strYear = startYear;

					if (startDay !== endDay || startMonth !== endMonth || startYear !== endYear) {
						eventsListWrapper.objEventList[i].showEndDate = true;
						eventsListWrapper.objEventList[i].endDay = endDay;
						eventsListWrapper.objEventList[i].endMonth = endMonth;
						eventsListWrapper.objEventList[i].endYear = endYear;
					}

					eventsListWrapper.objEventList[i].strMonth = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("MMM");
					eventsListWrapper.objEventList[i].intDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("DD");

					eventsListWrapper.objEventList[i].topics = [];
					eventsListWrapper.objEventList[i].topics.push(eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[i].Id]);

					component.set("v.events.Details__c", eventsListWrapper.objEventList[0].Details__c);

					eventsListWrapper.objEventList[0].Details__Clean__c = eventsListWrapper.objEventList[0].Details__c.replace(/(<([^>]+)>)/ig, "");

					self.setCustomFields(component, eventsListWrapper.objEventList, i);
				}

				component.set("v.wrappedEventsObj", eventsListWrapper);

				component.getEvent("detailReady").fire();
			} else {
				self.debug(component, "problem with getEventRecord: state = ", state);
			}
		});

		$A.enqueueAction(action);
	},


	//updating add to calendar button name as per provided by user in properties
	updateATCbuttonName: function (component, event, helper) {
		this.debug(component, 'updateATCButton', component.get("v.wrappedEventsObj"));

		$('.atcb-link').each(function () {
			$(this).html(component.get("v.addToCalendarButtonText"));
		});
	},

	initializeEventPageEdit: function (component, event, helper) {
		var body = component.find('editView');
		body.set("v.body", []);

		try {
			var topics = '';

			if (component.get("v.recordId") && component.get("v.recordId") !== '') {
				var topicList = component.get('v.wrappedEventsObj.objEventList')[0].topics;
				if (topicList[0] !== undefined) {
					topics = JSON.stringify(component.get('v.wrappedEventsObj.objEventList')[0].topics[0]);
				}
			}
			$A.createComponent('c:SVNSUMMITS_Create_Event', {
				'isEdit'        : true,
				'debugMode'     : component.get("v.debugMode"),
				'sObjectId'     : component.get("v.recordId"),
				'selectedTopics': topics,
				'useTopics'     : component.get('v.useTopics'),
				'showEventType' : component.get('v.showEventType'),
				'customField1'  : component.get('v.customField1'),
				'customLabel1'  : component.get('v.customLabel1'),
				'customField2'  : component.get('v.customField2'),
				'customLabel2'  : component.get('v.customLabel2'),
				'customField3'  : component.get('v.customField3'),
				'customLabel3'  : component.get('v.customLabel3'),
				'limitToSpecificGroups': component.get("v.limitToSpecificGroups")
			}, function (editView) {
					var op = component.find("editView");
					var editViewbody = op.get('v.body');

					editViewbody.push(editView);
					op.set("v.body", editViewbody);

					component.set("v.isEdit", true);
				});
		} catch (e) {
			this.debug(component, "initializeEventPageEdit exception:", e);
		}
	},

    initializeVolunteerForm: function (component, event, helper) {
        var body = component.find('editVolunteerView');
        body.set("v.body", []);

        try {
            var topics = '';

            if (component.get("v.recordId") && component.get("v.recordId") !== '') {
                topics = JSON.stringify(component.get('v.wrappedEventsObj.objEventList')[0].topics[0]);
            }
            $A.createComponent('c:SVNSUMMITS_Event_VolunteerNeedForm', {
                    // 'isEdit': true,
                    'recordId': component.get("v.recordId"),
                    'debugMode': component.get("v.debugMode")
                },
                function (editVolunteerView) {
                    var op = component.find("editVolunteerView");
                    var editVolunteerViewBody = op.get('v.body');
                    editVolunteerViewBody.push(editVolunteerView);
                    op.set("v.body", editVolunteerViewBody);
                    // component.set("v.isEdit", true);
                });
        } catch (e) {
            this.debug(component, "initializeVolunteerForm exception:", e);
        }
    },

	stripHtml: function (str) {
		return jQuery('<span>').html(str).text();
	},

	// adjust for guest user
	getTimeZone : function(eventsListWrapper) {
		return !eventsListWrapper.strTimeZone || eventsListWrapper.strTimeZone === 'GMT'
			? moment.tz.guess()
			: eventsListWrapper.strTimeZone;
	},

	getSitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function(response) {
			var sitePath = response.getReturnValue();
			var position = sitePath.lastIndexOf('/s');

			component.set("v.sitePrefix", sitePath.substring(0, position));
		});

		$A.enqueueAction(action);
	},

	debug: function (component, msg, variable) {
		var debugMode = component.get("v.debugMode");
		if (debugMode) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
})