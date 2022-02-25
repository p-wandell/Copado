// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getEventData: function(component, start, end, timezone, callback)  {
		let self = this;
		let filters  = this.getFilterString(component);
		console.log('calendar view - getEventData - start: ' + start + ' end: ' + end + ' filters: ' + filters);

		let params = {
			eventListFlag   : component.get("v.titletext") !== 'Recommended For You',
			numberofresults : component.get("v.numberofresults"),
			listSize        : component.get("v.listSize"),
			strfilterType   : component.get("v.filterType"),
			sortBy          : component.get("v.sortBy"),
			filterByTopic   : component.get("v.filterByTopic"),
			topicName       : component.get("v.topicValue"),
			searchTerm      : component.get("v.searchstr"),
			filterOn        : component.get("v.filterOn"),
			fromDate        : moment(start).format(this.custom.DATE_FORMAT),
			toDate          : moment(end).format(this.custom.DATE_FORMAT),
			listViewMode    : 'Calendar',
			customFields    : '',
			filters         : this.getFilterString(component)
		};

		this.doCallout(component, "c.getEventsList", params, false, 'Calendar View get events' ).then(
			result => {
				let eventsListWrapper = self.parseNamespace(component, result);
				const sitePrefix = component.get('v.sitePrefix');
				let events = [];
				eventsListWrapper.objEventList.forEach(function (eventItem) {
					let startDate = moment.tz(eventItem.Start_DateTime__c, eventsListWrapper.strTimeZone).format('YYYY-MM-DD HH:mm:ss');
					let endDate = eventItem.All_Day_Event__c
						? moment(eventItem.End_DateTime__c).add(1, 'days').format('YYYY-MM-DD HH:mm:ss')
						: moment.tz(eventItem.End_DateTime__c, eventsListWrapper.strTimeZone).format('YYYY-MM-DD HH:mm:ss');

					events.push({
						'title': eventItem.Name,
						'allDay': eventItem.All_Day_Event__c,
						'start': startDate,
						'end': endDate,
						'Id': eventItem.Id,
						'url': sitePrefix + '/event/' + eventItem.Id
					});
				});

				component.set('v.eventCalendarValues', events);
				component.set('v.totalResults', events.length);

				callback(events);
			});
	},

	// Initialize the calendar
	initializeCalendarJQ: function (component) {
		const calendar  = component.find('calendar').getElement();
		let   self = this;

		// needed in order to clear when applying filters
		$(calendar).fullCalendar('destroy');

		$(calendar).fullCalendar({
			header: {
				left: 'listWeek,month,agendaWeek,agendaDay',
				center: 'title',
				right: 'prev,today,next'
			},
			events: function(start, end, timezone, callback) {
				self.getEventData(component, start, end, timezone, callback);
			},
			eventClick: function (event) {
				if (event.url) {
					self.persistCalendarDate(event.start);
					let urlEvent = $A.get("e.force:navigateToURL");
					urlEvent.setParams({
						"url": event.url
					});
					urlEvent.fire();
					return false;
				}
			},
			eventLimit: true,
			views: {
				listWeek: {buttonText: 'List'},
				agenda: {eventLimit: 5}
			}

		});
	},

	calendarGotoDate : function(component, fromDate) {
		const calendar  = component.find('calendar').getElement();
		$(calendar).fullCalendar('gotoDate', fromDate);
	},

	calendarRefetchEvents: function(component) {
		const calendar  = component.find('calendar').getElement();
		$(calendar).fullCalendar('refetchEvents');
	},

	getFilterString: function (component) {
		//let filterString = this.getHiddenFilters(component);
		let filterString = '';

		let typeFilter = component.get('v.eventTypeFilter');

		if (typeFilter) {
			filterString += this.events.fields.eventType;
			filterString += this.custom.SEARCH_FIELD;
			filterString += typeFilter;
			filterString += this.custom.SEARCH_SEPARATOR;
		}

		let locationFilter = component.get('v.locationFilter');

		if (locationFilter) {
			filterString += this.events.fields.location;
			filterString += this.custom.SEARCH_FIELD;
			filterString += locationFilter;
			filterString += this.custom.SEARCH_SEPARATOR;
		}

		let customFilter = component.get('v.customFilter');

		if (customFilter) {
			filterString += customFilter;
		}

		return filterString;
	},

	getHiddenFilters: function (component) {
		let filterString = '';

		for (let pos=1; pos <= this.custom.MAX_FIELDS; pos++) {
			let customField = component.get('v.hiddenFilter'+pos);
			if (customField.length) {
				let customSearch = component.get('v.hiddenValue'+pos);

				if (customSearch.length) {
					filterString += customField + ':' + customSearch + ';';
				}
			}
		}

		return filterString;
	}
});