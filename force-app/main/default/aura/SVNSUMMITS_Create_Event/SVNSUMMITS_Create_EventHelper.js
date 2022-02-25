// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	// Method to initailize topics for dropdown
	initializeDropdown: function (component) {
		try {
			$(".topic")
				.addClass("ui fluid search")
				.dropdown({placeholder: "Select Topics"});

			var topics = component.get('v.selectedTopics');

			if (topics !== '') {
				topics = JSON.parse(topics);
				var tp = [];
				for (var t = 0; t < topics.length; t++) {
					tp.push(topics[t].TopicId);
				}
				window.setTimeout(
					$A.getCallback(function () {
						$(".topic").dropdown('set selected', tp);
					}), 2000
				);

			}

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

		} catch (e) {
			this.debug(component, null, e);
		}
	},

	// Method to fetch the topics
	getTopics: function (component) {
		this.doCallout(component, 'c.getTopics', {}, false, 'Get topics')
			.then($A.getCallback(function (values) {
				var valuesTemp = [];
				for (var value in values) {
					if (values.hasOwnProperty(value)) {
						valuesTemp.push({key: value, value: values[value]});
					}
				}
				component.set("v.topicValues", valuesTemp);
			}));
	},

	getGroupSetting: function(component){
		var self = this;
		this.doCallout(component, 'c.requireGroupMembership', {}, false, 'Get group settings - require membership')
			.then($A.getCallback(function (value) {
				component.set('v.requireGroups', value);
				self.debug(component, 'Groups enforced: ' + value);
			}));
	},

	getGroups: function (component) {
		this.doCallout(component, 'c.getGroups', {}, false, 'Get group list')
			.then($A.getCallback(function (values) {
				var valuesTemp = [];

				for (var value in values) {
					if (values.hasOwnProperty(value)) {
						valuesTemp.push({key: value, value: values[value]
						});
					}
				}

				component.set("v.groupValues", valuesTemp);
			}));
	},

	getGroupPostAll: function (component) {
		var self = this;
		this.doCallout(component, 'c.userAuthorizedToPost', {}, false, 'Get authorized to post')
			.then($A.getCallback(function (value) {
				component.set("v.canPostToAll", value);
				self.debug(component, 'Groups: Can post to ALL: ' + value);
			}));
	},

	showSpinner : function (component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.removeClass(spinnerSubmit, "slds-hide");
	},

	hideSpinner : function (component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.addClass(spinnerSubmit, "slds-hide");
	},

	// Method to submit and create event
	submitEventHelper: function (component, eventObj, allDayEventStartDate, allDayEventEndDate) {
		// prevent duplicates
		component.set('v.disableButton', true);

		var self = this;
		this.debug(component, 'submitEventHelper', eventObj);

		var strfilterByTopic = component.find("filterByTopic").get("v.value");
		var fileInput = component.find("image").getElement();

		if (component.get("v.isFileSelected") || component.get("v.isFileDeleted")) {
			this.deleteAttachment(component);
		}

		var action = component.get("c.saveEvents"); //added to test changed the method to 2

		action.setParams({
			"eventObj"            : eventObj,
			"strfilterByTopic"    : strfilterByTopic,
			"allDayEventStartDate": allDayEventStartDate, // added to test ,extra parameter
			"allDayEventEndDate"  : allDayEventEndDate
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			var spinnerSubmit = component.find("spinnerSubmit");
			$A.util.addClass(spinnerSubmit, 'hide');

			if (component.isValid() && state === "SUCCESS") {
				var resId = response.getReturnValue().Id;

				if (fileInput.files.length > 0 && resId !== null && resId.length > 0) {
					self.uploadImage(component, resId, fileInput.files);
				} else if (resId !== null && resId.length > 0) {
					self.gotoRecord(component, resId);
				}
			}

			if (state === "ERROR") {
				var errors = response.getError();
				self.debug(component, "Page Error : ", errors);

				if (errors[0] && errors[0].fieldErrors) {
					if (errors[0].fieldErrors.EntityId[0].message.length > 0) {
						component.set("v.strError", errors[0].fieldErrors.EntityId[0].message);
					}
				}

				if (errors[0] && errors[0].pageErrors) {
					component.set("v.strError", errors[0].pageErrors[0].message);
				}

				if (errors[0] && errors[0].message) {
					component.set("v.strError", errors[0].message);
				}
			}
		});
		$A.enqueueAction(action);
	},

	uploadImage: function (component, resId, files) {
		var sessionId = component.get("v.sessionId");
		var sfInstanceUrl = component.get("v.sfInstanceUrl");

		var client = new forcetk.Client();
		client.setSessionToken(sessionId, 'v36.0', sfInstanceUrl);
		client.proxyUrl = null;
		client.instanceUrl = sfInstanceUrl;

		var file = files[0];
		var self = this;
		var spinner = component.find("spinnerSubmit");

		client.createBlob('Attachment', {
			'ParentId': resId,
			'Name': file.name,
			'ContentType': file.type,
		}, file.name, 'Body', file, function (response) {
			$A.util.addClass(spinner, "hide");

			if (response.id !== null) {
				self.debug(component, 'success');
				self.gotoRecord(component, resId);
			} else {
				self.debug(component, 'error', response.errors);
				component.set("v.strAttachmentError", 'Error : ' + response.errors[0].message);
			}
		}, function (request, status, response) {
			$A.util.addClass(spinner, "hide");

			var res = JSON.parse(response);
			component.set("v.strAttachmentError", 'Error : ' + res[0].message);
			self.debug(component, 'error', res);
		});
	},

	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();

			component.set("v.sitePath", sitePath);

			// remove the trailing /s for the image
			if (sitePath[sitePath.length-1] === 's') {
				component.set("v.sitePrefix", sitePath.substring(0, sitePath.length-2));
			} else {
				component.set("v.sitePrefix", sitePath.replace("/s", "/"));
			}
		});
		$A.enqueueAction(action);
	},

	clearError: function (component) {
		component.set("v.disableButton", false);
		// var errorButton = document.getElementById('FillHeader');
		// errorButton.style.display = "none";
	},

	//Check for Button before creating an event
	toggleSubmitButton: function (component) {
		var valError = false;
		var errMsg   = "";
		var infoMsg  = "";
		this.clearError(component);


		var stDt;
		var stTme;
		if ($(".dateTime-inputDate input").attr("class") === 'form-control requiredField stdate input') {
			stDt = $(".dateTime-inputDate input").val();
			infoMsg += "Start Date = " + stDt + " ";
		}
		if ($(".dateTime-inputTime input").attr("class") === 'form-control requiredField stdate input') {
			stTme = $(".dateTime-inputTime input").val();
			infoMsg += "Start Time = " + stTme + " ";
		}
		this.debug(component, 'start date and time', infoMsg);


		if (component.get('v.eventName') === undefined ||
			component.get('v.eventName') === '') {
			valError = true;
			errMsg += "Name not valid. ";
		}

		if (!component.get('v.eventAllDay') &&
			(stDt === undefined || stDt.trim() === '' || stTme === undefined || stTme.trim() === '')) {
			valError = true;
			errMsg += "Not all day - date/time not set. ";
			//console.log("Not all day but date/time not set");
		}

		if (component.get('v.eventAllDay') &&
			(component.get('v.allDayEventStartDate') === undefined ||
				component.get('v.allDayEventStartDate') === '')) {
			valError = true;
			errMsg += "All day - date not set. ";
		}

		//console.log("all day but Date not set");
		this.debug(component, 'start date and time', stDt + stTme);

		if (component.get('v.eventLocationName') === undefined ||
			component.get('v.eventLocationName') === '') {
			valError = true;
			errMsg += "Location not set. ";
		}

		/*if (component.get('v.eventDetails') === undefined ||
		 component.get('v.eventDetails') === '') {
		 valError = true;
		 errMsg += "Detail not set. ";
		 }*/

		if (component.get('v.useTopics')) {
			if (component.find('filterByTopic').get('v.value') === undefined ||
				component.find('filterByTopic').get('v.value') === '') {
				valError = true;
				errMsg += "Topic not set. ";
			}
		}

		if (component.get('v.requireGroups'))
		{
			var group = component.get('v.eventGroupId');
			this.debug(component, " Group   = " + group);

			valError = group === undefined;
			if (valError) {
				errMsg += 'Require group selection. ';
			}
		}

		if (valError) {
			this.debug(component, errMsg);
			component.set("v.disableButton", true);
		}

		component.set('v.strError', errMsg);
		var inputMessage = component.find("inputErrorMessage");

		if (errMsg.length === 0) {
			$A.util.addClass(inputMessage, "slds-hide");
		} else {
			$A.util.removeClass(inputMessage, "slds-hide");
		}

	},

	get_SessionId: function (component) {
		var action = component.get("c.getSessionId");

		action.setCallback(this, function (actionResult) {
			component.set("v.sessionId", actionResult.getReturnValue());
		});
		$A.enqueueAction(action);
	},

	enablePricing: function (component, event, helper) {
		var cmpTarget = component.find('eventTicketPriceBlock');

		if (component.find('enablePricing').get("v.value") === true) {
			$A.util.addClass(cmpTarget, 'showDiv');
			$A.util.removeClass(cmpTarget, 'hideDiv');
		} else {
			$A.util.addClass(cmpTarget, 'hideDiv');
			$A.util.removeClass(cmpTarget, 'showDiv');
		}
	},

	enableThreshold: function (component, event, helper) {
		var nameSpace = component.get('v.nameSpace');
		var newEvent = component.get("v.eventObj");
		var cmpTarget = component.find('eventThresholdCountBlock');

		if (component.find('enableRSVP').get("v.value") === true) {
			$A.util.addClass(cmpTarget, 'showDiv');
			$A.util.removeClass(cmpTarget, 'hideDiv');
			newEvent[nameSpace + 'RSVP_Count_Threshold__c'] = 10;
		} else {
			$A.util.addClass(cmpTarget, 'hideDiv');
			$A.util.removeClass(cmpTarget, 'showDiv');
			newEvent[nameSpace + 'RSVP_Count_Threshold__c'] = 0;
		}

		component.set("v.eventObj", newEvent);
	},

	getEventsRecord: function (component, event, helper) {
		var self = this;
		var action = component.get("c.getEventRecord");

		action.setParams({
			eventRecordId: component.get("v.sObjectId"),
			customFields: this.getCustomFields(component)
		});
		component.set('v.attachmentName', 'No File Chosen');

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var nameSpace = component.get('v.nameSpace');

				var eventsListWrapper = response.getReturnValue();
				var eventObj = eventsListWrapper.objEventList[0];

				component.set("v.eventObj", eventObj);

				var allDayEvent = eventObj[nameSpace + 'All_Day_Event__c'];

				if (allDayEvent) {
					component.set('v.allDayEventStartDate', eventObj[nameSpace + 'Start_DateTime__c']);
					component.set('v.allDayEventEndDate', eventObj[nameSpace + 'End_DateTime__c']);
				} else {
					component.set('v.eventStartTime', eventObj[nameSpace + 'Start_DateTime__c']);
					component.set('v.eventEndTime', eventObj[nameSpace + 'End_DateTime__c']);
				}

				component.set('v.eventName',            eventObj.Name);
				component.set('v.eventAllDay',          allDayEvent);
				component.set('v.attachments',          eventObj.Attachments);
				component.set('v.eventDetails',         eventObj[nameSpace + 'Details__c']);
				component.set('v.eventLocationName',    eventObj[nameSpace + 'Location_Name__c']);
				component.set('v.eventEnablePricing',   eventObj[nameSpace + 'Enable_Pricing_Payment__c']);
				component.set('v.eventEnableRSVP',      eventObj[nameSpace + 'Enable_RSVP__c']);
				component.set('v.eventGroupId',         eventObj[nameSpace + 'GroupId__c']);
				component.set('v.eventLocationAddress', eventObj[nameSpace + 'Location_Address__c']);
				component.set('v.eventLocationURl',     eventObj[nameSpace + 'Location_URL__c']);
				component.set('v.eventPaymentURL',      eventObj[nameSpace + 'Payment_URL__c']);
				component.set('v.eventRSVPThreshold',   eventObj[nameSpace + 'RSVP_Count_Threshold__c']);
				component.set('v.eventTicketPrice',     eventObj[nameSpace + 'Ticket_Price__c']);
				component.set('v.eventVenueInfo',       eventObj[nameSpace + 'Venue_Information__c']);
				component.set('v.eventType',            eventObj[nameSpace + 'Event_Type__c']);

				for (var pos = 1; pos <= helper.custom.MAX_FIELDS; pos++) {
					var customField = component.get('v.customField' + pos);
					if (customField.length) {
						var customValue = eventObj[nameSpace + customField];
						if (customValue) {
							component.set('v.customValue' + pos, customValue);
						}
					}
				}

				if (moment().isAfter(eventObj[nameSpace + 'Start_DateTime__c'], 'day')) {
					if (!eventObj[nameSpace + 'All_Day_Event__c']) {
						// not clear why this is messing with UTC?
						//eventObj[nameSpace + 'Start_DateTime__c'] = moment().utc().format('YYYY-MM-DDThh:mm:ss') + 'Z';
					} else {
						var today = new Date();
						component.set('v.allDayEventStartDate', moment().format('YYYY-MM-DD'));
					}
				}

				if (eventObj[nameSpace + 'GroupId__c']) {
					var groupIdCmp = component.find("filterByGroup");
					groupIdCmp.set('v.value', eventObj[nameSpace + 'GroupId__c']);
				}

				component.set('v.allDayEventStartDate', eventObj[nameSpace + 'Start_DateTime__c']);
				component.set('v.allDayEventEndDate', eventObj[nameSpace + 'End_DateTime__c']);
				component.set('v.eventAllDay', allDayEvent);
				component.set('v.disableDateTime', allDayEvent);

				if (eventObj.Attachments && eventObj.Attachments.length > 0) {
					component.set('v.isAttachment', true);
					component.set('v.attachmentName', eventObj.Attachments[0].Name);
				}

				eventsListWrapper.objEventList[0].topics = [];

				if (eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[0].Id] !== undefined) {
					eventsListWrapper.objEventList[0].topics.push(
						eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[0].Id]
					);
				}

				self.setCustomFields(component, eventsListWrapper.objEventList, 0);

				self.enablePricing(component, event, helper);
				self.enableThreshold(component, event, helper);

				self.dumpEvent(component, 'getEventsRecord');

				$("document").ready(function () {
					$("#upload").change(function () {
						//alert('changed!');
						var a = document.getElementById('upload');
						if (a.value === "") {
							fileLabel.innerHTML = "No file Chosen";
						} else {
							var theSplit = a.value.split('\\');
							fileLabel.innerHTML = theSplit[theSplit.length - 1];
							jQuery('<div/>', {
								class: 'myCls',
								text: theSplit[theSplit.length - 1]
							}).appendTo('body');
							$('.myCls').html('');
						}
					});
				});

				self.clearError(component);
			}
		});
		$A.enqueueAction(action);
	},

	deleteAttachment: function (component) {
		var action = component.get("c.deleteAttachment");

		action.setParams({
			eventRecordId: component.get("v.sObjectId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var attachments = response.getReturnValue();
				component.set("v.attachments", attachments);
			}
		});
		$A.enqueueAction(action);
	},

	isInteger: function (value) {
		return typeof value === 'number' &&
			isFinite(value) &&
			Math.floor(value) === value;
	},

	dumpEvent: function (component, title) {
		this.debug(component, ' -------- ' + title + '--------');
		this.debug(component, 'Name:          ' + component.get('v.eventName'));
		this.debug(component, 'Type:          ' + component.get('v.eventType'));
		this.debug(component, 'Start Date:    ' + component.get('v.eventStartTime'));
		this.debug(component, 'End Date:      ' + component.get('v.eventEndTime'));
		this.debug(component, 'All day:       ' + component.get('v.eventAllDay'));
		this.debug(component, 'All Day Start: ' + component.get('v.allDayEventStartDate'));
		this.debug(component, 'All Day End:   ' + component.get('v.allDayEventEndDate'));
	}

})