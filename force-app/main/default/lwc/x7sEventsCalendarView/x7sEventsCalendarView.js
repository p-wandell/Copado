/*
* Copyright (c) 2020. 7summits Inc. All rights reserved.
*/
import {api, LightningElement, wire} from 'lwc';

import LANG from '@salesforce/i18n/lang';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import getEventsList from '@salesforce/apex/x7sEventsListController.getEventsList';
import getSitePrefix from '@salesforce/apex/x7sEventsListController.getSitePrefix';
import getTimeZone from '@salesforce/apex/x7sEventsListController.getTimeZone';

import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {custom, events, saveViewState, session, updateEventItem} from 'c/x7sEventsBase';

import {loadScript, loadStyle} from 'lightning/platformResourceLoader';
import EVENTSRESOURCE from '@salesforce/resourceUrl/x7sEventsResource';
import EVENTSCUSTOM from '@salesforce/resourceUrl/x7sEventsCustom';

export default class X7sEventsCalendarView extends NavigationMixin(LightningElement) {
	
	@api categories = '';
	@api numberofresults;
	@api listSize = 50;
	@api listViewMode = 'Calendar';
	@api sortBy = 'Upcoming';
	@api filterOn = 'None';
	@api searchstr;
	
	@api filterByTopic;
	@api filterType;
	@api topicValue;
	@api locationFilter;
	@api eventTypeFilter;
	@api customFilter;
	
	listId = "ID_1";
	sitePrefix;
	eventsListWrapper;
	events = [];
	eventCalendarValues = [];
	fullCalendarJsInitialised = false;
	error;
	isConCallbackExecuted = false;
	totalResults = 0;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.persistCalendarView();
		registerListener("topicchangeevent", this.handleTopicChange, this);
		registerListener("applyfilterevent", this.handleFilters, this);
		registerListener("sortbyevent", this.handleSortByEvent, this);
	}
	
	renderedCallback() {
		if (this.isConCallbackExecuted)
			return;
		this.isConCallbackExecuted = true;
		
		Promise.all([
			loadScript(this, EVENTSRESOURCE + '/EventsResource/jQuery/jquery-3.3.1.min.js'),
			loadScript(this, EVENTSCUSTOM + '/EventsCustom/moment.min.js'),
			loadScript(this, EVENTSCUSTOM + '/EventsCustom/moment-timezone-with-data.min.js'),
			
			loadScript(this, EVENTSRESOURCE + '/EventsResource/FullCalendar/fullcalendar.min.js'),
			//loadScript(this, EVENTSRESOURCE + '/EventsResource/FullCalendar/locales-all.min.js'),
			loadStyle(this, EVENTSRESOURCE + '/EventsResource/FullCalendar/fullcalendar.min.css'),
		
		]).then(() => {
			this.getSitePrefix();
		}).catch(error => {
			this.error = error;
			console.error("Error occurred on FullCalendarJS:" + JSON.stringify(error));
		})
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	getSitePrefix() {
		getSitePrefix().then(result => {
			this.sitePath = result;
			let position = this.sitePath.lastIndexOf('/s');
			this.sitePrefix = this.sitePath.substring(0, position);
			getTimeZone()
				.then(timeZone => {
					this.initializeCalendarJQ(timeZone);
					this.calendarGotoDate(this.retrieveCalendarDate() || moment());
					this.clearCaledarDate();
				})
		}).catch(error => {
			this.error = error;
			console.error(this.error);
		})
	}
	
	initializeCalendarJQ(userTimeZone) {
		const calendar = this.template.querySelector('div.customCalendarView');
		let userLocale = LANG;
		
		//console.log('Setting timezone to : ' + userTimeZone);
		//console.log('user locale   : ' + userLocale);
		
		// needed in order to clear when applying filters
		$(calendar).fullCalendar('destroy');
		
		$(calendar).fullCalendar({
			header: {
				left: 'prev,today,next',
				center: 'title',
				right: 'listWeek,month,agendaWeek,agendaDay'
			},
			timeZone: 'local',
			locale: userLocale,
			events: (start, end, timezone, callback) => {
				this.getEventData(start, end, timezone, callback);
			},
			eventClick: (event) => {
				if (event.Id) {
					this.persistCalendarDate(event.start);
					this.gotoRecord(event.Id);
					return false;
				}
			},
			eventLimit: true,
			views: {
				agenda: {eventLimit: 5}
			}
		});
	}
	
	retrieveCalendarDate() {
		let start = sessionStorage.getItem(session.calendarView);
		return start ? moment(start) : '';
	}
	
	getEventData(start, end, timezone, callback) {
		let params = {
			eventListFlag: false,
			numberofresults: this.numberofresults,
			listSize: this.listSize,
			strfilterType: this.filterType,
			sortBy: this.sortBy,
			filterByTopic: this.filterByTopic,
			topicName: this.topicValue,
			searchTerm: this.searchstr,
			filterOn: this.filterOn,
			fromDate: moment(start).format(custom.DATE_FORMAT),
			toDate: moment(end).format(custom.DATE_FORMAT),
			listViewMode: 'Calendar',
			customFields: '',
			filters: this.getFilterString()
		};
		
		getEventsList(params).then(result => {
			this.eventsListWrapper = result;
			
			// use the SF User timezone setting
			const timeZone = this.eventsListWrapper.strTimeZone;
			console.log('Calendar View Timezone: ' + timeZone);
			
			let eventList = [];
			
			console.log('CALENDAR VIEW');
			let languageEnabled = this.eventsListWrapper.languageEnabled;
			let userLanguage = this.eventsListWrapper.userLanguage;
			let isGuestUser = this.eventsListWrapper.isGuestUser;
			let eventName;
			
			this.eventsListWrapper.objEventList.forEach(event => {
				let eventItem = updateEventItem(event);
				
				// for all day events, use the data as UTC, otherwise apply the user's timezone
				let startDate = eventItem.All_Day_Event__c ? moment(eventItem.localeStartDate).utc() : moment(eventItem.localeStartDate).tz(timeZone);
				// Have to add a day here for the end date for FullCalendar
				let endDate = eventItem.All_Day_Event__c ? moment(eventItem.localeEndDate).utc().add(1, 'd') : moment(eventItem.localeEndDate).tz(timeZone);
				
				eventName = eventItem.Name;
				if (!isGuestUser && languageEnabled) {
					if (eventItem.Language__c !== userLanguage) {
						eventName = eventItem.X7S_Event_Translation__r[0].Title__c;
					}
				}
				
				eventList.push({
					'Id': eventItem.Id,
					'allDay': eventItem.All_Day_Event__c,
					'start': startDate,
					'end': endDate,
					'title': eventName,
					'url': '/event/' + eventItem.Id
				});
			});
			
			this.eventCalendarValues = eventList;
			this.totalResults = eventList.length;
			fireEvent(this.pageRef, 'calendartotalevents', {id: this.listId, value: this.totalResults});
			
			console.log(eventList);
			callback(eventList);
		});
	}
	
	getFilterString() {
		let filterString = '';
		let typeFilter = this.eventTypeFilter;
		if (typeFilter) {
			filterString += events.fields.eventType;
			filterString += custom.SEARCH_FIELD;
			filterString += typeFilter;
			filterString += custom.SEARCH_SEPARATOR;
		}
		
		let locationFilter = this.locationFilter;
		if (locationFilter) {
			filterString += events.fields.location;
			filterString += custom.SEARCH_FIELD;
			filterString += locationFilter;
			filterString += custom.SEARCH_SEPARATOR;
		}
		
		let customFilter = this.customFilter;
		if (customFilter) {
			filterString += customFilter;
		}
		return filterString;
	}
	
	updateEventsWrapper(eventsListWrapper) {
		eventsListWrapper.objEventList.forEach(eventItem => {
			updateEventItem(eventItem);
		});
		
		return eventsListWrapper;
	}
	
	setCustomFields(objEventList, index) {
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			
			if (customField && customField.length) {
				let fieldSet = true;
				let fieldParts = customField.split('.');
				let fieldValue = objEventList[index];
				
				for (let part = 0; part < fieldParts.length; part++) {
					if (fieldValue[fieldParts[part]])
						fieldValue = fieldValue[fieldParts[part]];
					else {
						fieldSet = false;
						break;
					}
				}
				objEventList[index]['customField' + pos] = fieldSet ? fieldValue : '';
			}
		}
	}
	
	gotoRecord(recordId) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				objectApiName: custom.EVENT_OBJ,
				actionName: 'view'
			}
		});
	}
	
	persistCalendarDate(startDate) {
		sessionStorage.setItem(session.calendarView, moment(startDate).format('YYYY-MM-DD'));
	}
	
	calendarGotoDate(fromDate) {
		const calendar = this.template.querySelector('div.customCalendarView');
		$(calendar).fullCalendar('gotoDate', fromDate);
	}
	
	calendarRefetchEvents() {
		const calendar = this.template.querySelector('div.customCalendarView');
		$(calendar).fullCalendar('refetchEvents');
	}
	
	clearCaledarDate() {
		sessionStorage.removeItem(session.calendarView);
	}
	
	persistCalendarView() {
		saveViewState(events.listViewMode.Calendar);
	}
	
	handleTopicChange(evt) {
		if (!this.isConCallbackExecuted) {
			return;
		}
		
		if (this.listId === evt.id) {
			this.filterByTopic = evt.value;
			this.calendarRefetchEvents();
		}
	}
	
	handleFilters(evt) {
		if (!this.isConCallbackExecuted) {
			return;
		}
		
		if (this.listId === evt.id) {
			this.locationFilter = evt.locationFilter;
			this.eventTypeFilter = evt.eventTypeFilter;
			this.customFilter = evt.customfilterString;
			this.calendarRefetchEvents();
			this.fromDate = evt.fromDate;
			this.calendarGotoDate(this.fromDate ? moment(this.fromDate) : moment())
		}
	}
	
	handleSortByEvent(evt) {
		if (this.listId === evt.id) {
			this.sortBy = evt.value;
			this.calendarRefetchEvents();
		}
	}
}