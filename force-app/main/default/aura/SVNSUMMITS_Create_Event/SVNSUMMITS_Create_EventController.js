// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		var nameSpace = helper.getNameSpacePrefix(component);
		component.set('v.nameSpace', nameSpace);

		var url = window.location.href;
		var splitUrl = url.split("/s/");
		component.set("v.sfInstanceUrl", splitUrl[0]);

		helper.get_SitePrefix(component);
		helper.get_SessionId(component);
		helper.getTopics(component);

		if (component.get('v.showEventType')) {
			helper.doCallout(component, 'c.getPicklistValues',
				{
					objName: helper.custom.EVENT_OBJ,
					fieldName: helper.events.fields.eventType
				}, false, 'Get Event Types')
				.then($A.getCallback(function (results) {
					component.set('v.eventTypeValues', results);
					if (component.get('v.showEventType') && !component.get('v.isEdit')) {
						component.set('v.eventType', results[0]);
					}
				}));
		}

		var handlingGroups = component.get("v.limitToSpecificGroups");

		if (handlingGroups) {
			helper.getGroupSetting(component);
			helper.getGroups(component);
			helper.getGroupPostAll(component);
		}

		if (component.get('v.isEdit') === true) {
			helper.getEventsRecord(component, event, helper);
		}

		if (component.get("v.eventObj.RSVP_Count_Threshold__c") === '') {
			component.set("v.eventObj.RSVP_Count_Threshold__c", '10');
		}

		helper.initializeDropdown(component);
		helper.hideSpinner(component);
	},

	initializeUI: function (component, event, helper) {
		helper.initializeDropdown(component);

		$('#stDate , #endDate').click(function () {
			if ($(window).scrollTop() > 700) {
				$(window).scrollTop(250);
			}
		});

		/*020616 - Safari and Mozilla fixes for input type file*/
		$(function () {
			var verOffset;
			var nAgt = navigator.userAgent;
			if ((verOffset = nAgt.indexOf("Safari")) !== -1) {
				if ((verOffset = nAgt.indexOf("Version")) !== -1) {
					$('.attachEdit').addClass('attachEditSafari');
				}
			}
			else if ((verOffset = nAgt.indexOf("Firefox")) !== -1) {
				$('.attachEdit').addClass('attachEditMozilla');
			}
		});
		/*020616 - Safari fixes for input type file*/
	},

	triggerButtonCheck: function (component, event, helper) {
		component.set('v.disableDateTime', component.get('v.eventAllDay'));
		helper.toggleSubmitButton(component);
	},

	enableThreshold: function (component, event, helper) {
		helper.enableThreshold(component, event, helper);
	},

	//Check for enable pricing section on create event page
	enablePricing: function (component, event, helper) {
		helper.enablePricing(component, event, helper);
	},

	//Check for disable dates on create event page
	disableDates: function (component, event, helper) {
		component.set('v.disableDateTime', component.get('v.eventAllDay'));
		helper.toggleSubmitButton(component);
	},

	//Check for validations messages on create event page
	submitEvent: function (component, event, helper) {
		try {
			var nameSpace = component.get("v.nameSpace");

			//helper.showSpinner(component);

			component.set("v.strError", null);
			component.set("v.strAttachmentError", null);
			component.set("v.isBrowseError", false);

			if (component.get('v.eventAllDay') === true) {
				$('.dateTime-inputTime').hide();
			} else {
				$('.dateTime-inputTime').show();
			}

			var fileInput = component.find("image").getElement();
			var allDayEventStartDate;
			var allDayEventEndDate;

			if (component.get('v.eventAllDay')) {
				// want the date portion only
				var startDate = component.get("v.allDayEventStartDate");
				if (startDate) {
					allDayEventStartDate = component.get("v.allDayEventStartDate").split('T')[0];  // added to test
				}

				var endDate = component.get("v.allDayEventEndDate");
				if (endDate) {
					allDayEventEndDate = endDate.split('T')[0];
				} else {
					// same day
					if (allDayEventEndDate) {
						allDayEventEndDate = allDayEventStartDate;
					}
				}
			} else {
				allDayEventStartDate = component.get("v.eventStartTime");
				allDayEventEndDate   = component.get("v.eventEndTime");
			}

			var isError = false;
			// Validation message for location if empty or spaces check
			var locationCMP = component.find("eventLocationName");
			if (!locationCMP.get("v.value") || locationCMP.get("v.value").trim() === "") {
				locationCMP.set("v.errors", [{message: "Please fill out the Event Location."}]);
				isError = true;
			} else {
				if (locationCMP.get("v.value").length > 255) {
					locationCMP.set("v.errors", [{message: "Event Location cannot exceed 255 characters. Please enter a location less than 255 characters."}]);
					isError = true;
				} else {
					locationCMP.set("v.errors", null);
				}
			}

			var eventAddressCMP = component.find("eventAddress");
			if (!eventAddressCMP.get("v.value") || eventAddressCMP.get("v.value").trim() === "") {
				eventAddressCMP.set("v.errors", null);
			} else {
				if (eventAddressCMP.get("v.value").length > 255) {
					eventAddressCMP.set("v.errors", [{message: "Event Address cannot exceed 255 characters. Please enter address less than 255 characters."}]);
					isError = true;
				} else {
					eventAddressCMP.set("v.errors", null);
				}
			}

			var eventDetails = component.get('v.eventDetails');
			if (! eventDetails) {
				component.set('v.validDetails', false);
				isError = true;
			} else {
				component.set('v.validDetails', true);
			}

			// Validation for description field for null check
			// var eventDetailCmp = component.find("eventDetail");
			// if (!eventDetailCmp.get("v.value") || eventDetailCmp.get("v.value").trim().length <= 0) {
			// 	//eventDetailCmp.set("v.errors", [{message: "Please fill out the Event Description."}]);
			// 	isError = true;
			// } else {
			// 	//eventDetailCmp.set("v.errors", null);
			// }

			// Validation message for Event title if empty and spaces check and length if more than 80 characters
			var eventNameCmp = component.find("eventName");
			if (!eventNameCmp.get("v.value") || eventNameCmp.get("v.value").trim() === "") {
				eventNameCmp.set("v.errors", [{message: "Please fill out the Event Name."}]);
				isError = true;
			} else {
				if (eventNameCmp.get("v.value").length > 80) {
					eventNameCmp.set("v.errors", [{message: "Event Title cannot exceed 80 characters. Please enter a title less than 80 characters."}]);
					isError = true;
				} else {
					eventNameCmp.set("v.errors", null);
				}
			}

			// Validation message for Date validations
			var eventStartDateCmp = component.find("eventStartDate");
			var eventStartDateCmp1 = component.find("eventStartDate_dateOnly");
			var frmDtStr;
			var toDtStr;
			var startDate;
			var endDate;

			try {
				eventStartDateCmp.set("v.errors", null);
				component.find("eventEndDateTime").set("v.errors", null);
			} catch (e) {
				//console.log(e);
			}

			if (component.get('v.eventAllDay') !== true) {
				if (!eventStartDateCmp.get("v.value") || eventStartDateCmp.get("v.value").trim() === "") {
					eventStartDateCmp.set("v.errors", [{message: "Please Select Event Start Date."}]);
					isError = true;
				} else {

					eventStartDateCmp.set("v.errors", null);
					startDate = moment(component.find("eventStartDate").get("v.value")).format('YYYY-MM-DD HH:mm:ss');
					frmDtStr = moment(startDate).toDate();
				}

				if (component.find("eventEndDateTime").get("v.value") !== null) {
					endDate = moment(component.find("eventEndDateTime").get("v.value")).format('YYYY-MM-DD HH:mm:ss');
					toDtStr = moment(endDate).toDate();
				}

				if (moment().isAfter(startDate, 'day')) {
					component.find("eventStartDate").set("v.errors", [{message: "Start Date must be greater than or equal to today."}]);
					component.find("eventEndDateTime").set("v.errors", null);
					isError = true;
				} else if (toDtStr !== '' && toDtStr && moment(toDtStr).isBefore(frmDtStr, 'day')) {
					eventStartDateCmp.set("v.errors", null);
					component.find("eventEndDateTime").set("v.errors", [{message: "To Date Can not be less than From Date."}]);
					isError = true;
				} else {
					eventStartDateCmp.set("v.errors", null);
					component.find("eventEndDateTime").set("v.errors", null);
				}
			} else {
				if (!eventStartDateCmp1.get("v.value") || eventStartDateCmp1.get("v.value").trim() === "") {
					eventStartDateCmp1.set("v.errors", [{message: "Please Select Event Start Date."}]);
					isError = true;
				} else {
					eventStartDateCmp1.set("v.errors", null);
					startDate = moment(component.find("eventStartDate_dateOnly").get("v.value")).format('YYYY-MM-DD HH:mm:ss');
					frmDtStr = moment(startDate).toDate();
				}

				if (component.find("eventEndDate").get("v.value") !== null) {
					endDate = moment(component.find("eventEndDate").get("v.value")).format('YYYY-MM-DD HH:mm:ss');
					component.find("eventEndDate").set("v.errors", null);
					toDtStr = moment(endDate).toDate();
				}

				if (moment().isAfter(moment(startDate), 'day')) {
					component.find("eventStartDate_dateOnly").set("v.errors", [{message: "Start Date must be greater than or equal to today."}]);
					isError = true;
				} else if (toDtStr !== '' && toDtStr && moment(toDtStr).isBefore(frmDtStr, 'day')) {
					eventStartDateCmp1.set("v.errors", null);
					component.find("eventEndDate").set("v.errors", [{message: "To Date Can not be less than From Date."}]);
					isError = true;
				} else {
					component.find("eventStartDate_dateOnly").set("v.errors", null);
					component.find("eventEndDate").set("v.errors", null);
				}
			}

			// Validation message for attachments
			if (fileInput.files.length > 0 && fileInput.files[0].type.indexOf("image") === -1) {
				isError = true;
				component.set("v.isBrowseError", true);
				component.set("v.strError", "Selected file must be an image.");
			} else if (fileInput.files.length > 0 && fileInput.files[0].size > 25000000) {
				isError = true;
				component.set("v.isBrowseError", true);
				component.set("v.strError", "Error : Image size must be less than 25MB.");
			} else {
				if (component.get("v.isEdit") &&
					component.get("v.attachmentName") === 'No File Chosen' &&
					component.get("v.isAttachment")) {
					component.set('v.isFileDeleted', true);
				}
				component.set("v.isBrowseError", false);
				component.set("v.strError", null);
			}

			// Validation for topics to be selected
			if (component.get('v.useTopics')) {
				var filterByTopicCmp = component.find("filterByTopic");

				if (!filterByTopicCmp.get("v.value") || filterByTopicCmp.get("v.value").trim() === "") {
					filterByTopicCmp.set("v.errors", [{message: "Please Select Topics."}]);
					isError = true;
				} else {
					filterByTopicCmp.set("v.errors", null);
				}
			}

			//Updated on 24-5 code to check length of payment url field
			var paymentUrlCmp = component.find("eventExternalPaymentURL");
			if (!paymentUrlCmp.get("v.value") || paymentUrlCmp.get("v.value").trim() === "") {
				paymentUrlCmp.set("v.errors", null);
			} else {
				if (paymentUrlCmp.get("v.value").length > 255) {
					isError = true;
					paymentUrlCmp.set("v.errors", [{message: "Payment URL cannot exceed 255 characters. Please enter a URL less than 255 characters."}]);
				} else {
					paymentUrlCmp.set("v.errors", null);
				}
			}

			if (component.find('enableRSVP').get("v.value") === true) {
				var eventThresholdCountCmp = component.find('eventThresholdCount');
				var eventThresholdCountValue = eventThresholdCountCmp.get("v.value");

				//if (!eventThresholdCountValue || (!Number.isInteger(eventThresholdCountValue) && eventThresholdCountValue.trim() === "")) {
				if (!eventThresholdCountValue || (!helper.isInteger(eventThresholdCountValue) && eventThresholdCountValue.trim() === "")) {
					eventThresholdCountCmp.set("v.errors", [{message: "Please Fill out RSVP counter."}]);
					isError = true;
				} else {
					eventThresholdCountCmp.set("v.errors", null);
				}
			}

			if (isError === true) {
				helper.hideSpinner(component);
			} else {
				helper.dumpEvent(component, 'submitEvent');
				helper.debug(component, 'allDayEventStartDate: ' + allDayEventStartDate);
				helper.debug(component, 'allDayEventEndDate  : ' + allDayEventEndDate);

				var eventObj = component.get("v.eventObj");
				var allDayEvent = component.get('v.eventAllDay');

				eventObj['Name']    = component.get('v.eventName');
				eventObj[nameSpace + 'All_Day_Event__c'] = allDayEvent;
				eventObj[nameSpace + 'Details__c'] = component.get('v.eventDetails');
				eventObj[nameSpace + 'Enable_Pricing_Payment__c'] = component.get('v.eventEnablePricing');
				eventObj[nameSpace + 'Enable_RSVP__c'] = component.get('v.eventEnableRSVP');
				eventObj[nameSpace + 'End_DateTime__c'] = allDayEvent ? component.get('v.allDayEventEndDate') :  component.get('v.eventEndTime');
				eventObj[nameSpace + 'Location_Address__c'] = component.get('v.eventLocationAddress');
				eventObj[nameSpace + 'Location_Name__c'] = component.get('v.eventLocationName');
				eventObj[nameSpace + 'Location_URL__c'] = component.get('v.eventLocationURl');
				eventObj[nameSpace + 'Payment_URL__c'] = component.get('v.eventPaymentURL');
				eventObj[nameSpace + 'RSVP_Count_Threshold__c'] = component.get('v.eventRSVPThreshold');
				eventObj[nameSpace + 'Start_DateTime__c'] = allDayEvent ? component.get('allDayEventStartDate') : component.get('v.eventStartTime');
				eventObj[nameSpace + 'Ticket_Price__c'] = component.get('v.eventTicketPrice');
				eventObj[nameSpace + 'Venue_Information__c'] = component.get('v.eventVenueInfo');
				eventObj[nameSpace + 'Event_Type__c'] = component.get('v.eventType');

				// add custom fields
				for (var pos = 1; pos <= helper.custom.MAX_FIELDS; pos++) {
					var customField = component.get('v.customField' + pos);
					if (customField.length) {
						var customValue = component.get('v.customValue' + pos);
						if (customValue) {
							eventObj[nameSpace + customField] = customValue;
						}
					}
				}

				// get/clear the selected group
				var groupIdCmp = component.find("filterByGroup");
				eventObj[nameSpace + 'GroupId__c'] = groupIdCmp ? groupIdCmp.get("v.value") : '';

				helper.hideSpinner(component);
				helper.submitEventHelper(component, eventObj, allDayEventStartDate, allDayEventEndDate);
			}
		} catch (e) {
			helper.hideSpinner(component);
			helper.debug(component, 'Exception e', e);
		}
	},

	handleCancelButton: function (component, event, helper) {
		if (component.get("v.isEdit")) {
			component.set('v.isEdit', false);
			helper.gotoRecord(component, component.get('v.sObjectId'));
		} else {
			helper.gotoUrl(component, component.get("v.allEventsUrl"));
		}
	},

	notifyFileSelected: function (component, event, helper) {
		var fileInput = component.find("image").getElement();
		if (fileInput.files.length > 0) {
			component.set('v.isFileSelected', true);
		} else {
			component.set('v.isFileSelected', false);
			component.set("v.attachmentName", 'No File Chosen');
		}
	}
})