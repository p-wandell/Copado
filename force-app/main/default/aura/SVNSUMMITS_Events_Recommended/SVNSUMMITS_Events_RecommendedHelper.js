// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getEventList: function (component) {
		var self = this;

		// Load all contact data
		var titletext = component.get("v.titletext");
		var numberofresults = component.get("v.numberofresults");
		var Contactdetailpage = component.get("v.eventDetailURL");
		var searchstr = component.get("v.searchstr");
		var filterOn = component.get("v.filterOn");
		var debugMode = component.get("v.debugMode");
		var displayMode = component.get("v.displayMode");
		var sortBy = component.get("v.sortBy");

		component.set("v.titletext", titletext);
		component.set("v.eventDetailURL", Contactdetailpage);
		component.set("v.searchstr", searchstr);
		component.set("v.displayMode", displayMode);
		component.set("v.filterOn", filterOn);

		var action = component.get("c.getEvents");

		action.setParams({
			eventListFlag: component.get("v.titletext") == 'Recommended For You' ? false : true,
			numberofresults: component.get("v.numberofresults"),
			listSize: component.get("v.listSize"),
			strfilterType: component.get("v.filterType"),
			strRecordId: component.get("v.topicValue"),
			networkId: '',
			sortBy: component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			topicName: '',
			filterBySearchTerm: '',
			searchTerm: component.get("v.searchstr"),
			filterOn: component.get("v.filterOn"),
			fromDate: component.get("v.fromDate"),
			toDate: component.get("v.toDate")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			this.debug(component, "State of the action --->>", state);

			if (component.isValid() && state === "SUCCESS") {
				this.debug(component, "RES --->>", response.getReturnValue());
				var eventsListWrapper = this.parseNamespace(component, response.getReturnValue());

				eventsListWrapper.strTimeZone = self.getTimeZone(eventsListWrapper);

				for (var i = 0; i < eventsListWrapper.objEventList.length; i++) {

					//var endDate =  eventsListWrapper.objEventList[i].End_DateTime__c.getTime();
					var startDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
					var startTime = moment(startDate).toDate();

					var endDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
					var endTime = moment(endDate).toDate();

					var diffDays = Math.round(Math.abs((endTime.getTime() - startTime.getTime()) / (24 * 60 * 60 * 1000)));
					eventsListWrapper.objEventList[i].daysOfMultiDaysEvent = diffDays;

					var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
					eventsListWrapper.objEventList[i].strDay = days[startTime.getDay()];

					eventsListWrapper.objEventList[i].strMonth = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("MMM");
					eventsListWrapper.objEventList[i].intDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("DD");
					eventsListWrapper.objEventList[i].strMinute = moment(startTime).format('HH:mm a');

					if (eventsListWrapper.objEventList[i].Name.length > 15) {
						eventsListWrapper.objEventList[i].Name = eventsListWrapper.objEventList[i].Name.substring(0, 15);
					}

					eventsListWrapper.objEventList[i].topics = [];
					eventsListWrapper.objEventList[i].topics.push(eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[i].Id]);
					this.debug(component, '>>>>topics>>>>', eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[i].Id]);
				}

				component.set("v.wrappedEvents", eventsListWrapper);

			}
		});
		$A.enqueueAction(action);
	},

	// adjust for guest user
	getTimeZone: function (eventsListWrapper) {
		return !eventsListWrapper.strTimeZone || eventsListWrapper.strTimeZone === 'GMT'
			? moment.tz.guess()
			: eventsListWrapper.strTimeZone;
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