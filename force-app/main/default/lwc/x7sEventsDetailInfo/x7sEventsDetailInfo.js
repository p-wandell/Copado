/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
*/
import {api, LightningElement, wire} from 'lwc';

import {updateEventItem} from 'c/x7sEventsBase';
import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import labelAddToCalendar from "@salesforce/label/c.x7sEventsDetailInfoAddToCalendar";
import labelEventInfoTitle from "@salesforce/label/c.x7sEventsLabelEvtInfoTitle";

export default class X7sEventsDetailInfo extends NavigationMixin(LightningElement) {
	
	@api recordId;
	@api hideAddToCalendar = false;
	@api addToCalendarButtonText = labelAddToCalendar;
	@api atcPlainText = false;
	@api customClass = "";
	@api listId = "ID_1";
	@api variant = "featured";
	@api eventInfoTitle = labelEventInfoTitle;
	
	eventsListWrapper;
	event;
	eventVenue;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		registerListener("geteventinfo", this.handleEventInfo, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get timeZone(){
		return this.event.All_Day_Event__c === true ? 'UTC': this.eventsListWrapper.strTimeZone;
	}
	
	get componentClass() {
		return `x7s-events-detail-info ${this.customClass}`;
	}
	
	get isNotAllDayEvent() {
		return !this.event.All_Day_Event__c;
	}
	
	get IsLocationName() {
		return !!this.event.Location_Name__c;
	}
	
	get IsLocationURL() {
		return !!this.event.Location_URL__c;
	}
	
	get isLocationAdd() {
		return !!this.event.Location_Address__c;
	}
	
	get isEventVenue() {
		return !!this.eventVenue;
	}
	
	navigateToLocation() {
		this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.event.Location_URL__c
				}
			},
			false
		);
	}
	
	handleEventInfo(event) {
		if (this.listId === event.id) {
			this.eventsListWrapper = event.value;
			
			let eventItem = updateEventItem(this.eventsListWrapper.objEventList[0]);
			
			//Event Venue
			this.eventVenue = eventItem.Venue_Information__c;
			if (this.eventsListWrapper.isGuestUser ? false : !!this.eventsListWrapper.languageEnabled) {
				if (eventItem.Language__c !== this.eventsListWrapper.userLanguage) {
					this.eventVenue = eventItem.X7S_Event_Translation__r[0].Venue_Information__c;
				}
			}
			
			//For Calendar
			let communityUrl = !this.hideAddToCalendar ? window.location.href : '';
			if (communityUrl) {
				let summary = this.eventsListWrapper.detailsForAddToCalendar;
				
				// Used for Microsoft Outlook, which does support HTML
				if (this.atcPlainText) {
					if (this.eventsListWrapper.summaryForAddToCalendar) {
						// IF a summary is defined, create a html version with the link to the event.
						summary = this.eventsListWrapper.summaryForAddToCalendar;
					}
				}
				
				if (summary) {
					eventItem.Summary__c = ' <HTML><BODY><br/><br/><a href=\"'
						+ communityUrl
						+ '\">'
						+ communityUrl
						+ '</a></BODY></HTML>'
						+ '\r\n '
						+ summary;
				}
			}
			
			this.event = eventItem;
		}
	}
	
	addToCalendar(evt) {
		const fileName = 'event.ics';
		const wrapper = this.eventsListWrapper
		const eventItem = wrapper.objEventList[0];
		
		// build text file
		const currentDate = new Date();
		const newLine = '\r\n';
		const version = '2.0';
		const company = '7 Summits Inc.';
		const product = 'Events';
		const language = eventItem.Language__c;
		const website = '7summitsinc.com'
		const id = eventItem.Id + currentDate.getTime();
		const durationSection = this.getEventDurationSection(eventItem);
		const name = eventItem.Name;
		let summary = eventItem.Summary__c;
		const location = eventItem.Location_Name__c;
		
		// Remove HTML from Summary
		const div = document.createElement('div');
		div.innerHTML = summary;
		const summaryWithOutHtml = div.innerText;
		
		const dtStamp = this.getDateTimeString(currentDate);
		
		let text = 'BEGIN:VCALENDAR' + newLine
			+ 'VERSION:' + version + newLine
			+ 'PRODID:' + '-//' + company + '//' + product + '//' + language + newLine
			+ 'BEGIN:VEVENT' + newLine
			+ 'DTSTAMP:' + dtStamp + newLine
			+ 'STATUS:CONFIRMED' + newLine
			+ 'UID:' + id + '@' + website + newLine
			+ durationSection
			+ 'SUMMARY:' + name + newLine
			+ 'DESCRIPTION:' + summaryWithOutHtml + newLine          // Standard Description does not support HTML
			+ 'X-ALT-DESC;FMTTYPE=text/html:' + summary + newLine
			+ 'LOCATION:' + location + newLine
			+ 'BEGIN:VALARM' + newLine
			+ 'TRIGGER:-PT15M' + newLine
			+ 'DESCRIPTION: ' + newLine
			+ 'ACTION:DISPLAY' + newLine
			+ 'END:VALARM' + newLine
			+ 'TRANSP:OPAQUE' + newLine
			+ 'END:VEVENT' + newLine
			+ 'END:VCALENDAR';
		
		let element = document.createElement('a');
		element.setAttribute('href', 'data:text/calendar;charset=utf-8,' + encodeURIComponent(text));
		element.setAttribute('download', fileName);
		
		element.style.display = 'none';
		document.body.appendChild(element);
		
		element.click();
		
		document.body.removeChild(element);
	}
	
	getEventDurationSection(eventItem) {
		const newLine = '\r\n';
		let startDate = '';
		let endDate = '';
		let duration = '';
		let durationSection = 'DTSTART:';
		
		if (eventItem.All_Day_Event__c) {
			startDate = this.getDateString(new Date(eventItem.All_Day_Start__c));
			duration = this.getAllDayEventDuration(eventItem);
			
			durationSection += startDate + newLine;
			durationSection += "DURATION:" + duration + newLine;
		} else {
			startDate = this.getDateTimeString(new Date(eventItem.localeStartDate));
			endDate = this.getDateTimeString(new Date(eventItem.localeEndDate));
			
			durationSection += startDate + newLine;
			durationSection += 'DTEND:' + endDate + newLine
		}
		
		return durationSection;
	}
	
	getDateTimeString(dateTime) {
		const month = dateTime.getUTCMonth() + 1;
		const day = dateTime.getUTCDate();
		
		return dateTime.getUTCFullYear()
			+ this.padItem(month)
			+ this.padItem(day)
			+ 'T'
			+ this.padItem(dateTime.getUTCHours())
			+ this.padItem(dateTime.getUTCMinutes())
			+ this.padItem(dateTime.getUTCSeconds())
			+ 'Z';
	}
	
	getDateString(date) {
		const month = date.getUTCMonth() + 1;
		const day = date.getUTCDate();
		
		return date.getUTCFullYear()
			+ this.padItem(month)
			+ this.padItem(day);
		
	}
	
	getAllDayEventDuration(eventItem) {
		const millisecondsPerDay = 24 * 60 * 60 * 1000; // Number of milliseconds per day
		let duration = Math.round(Math.abs(
			(new Date(eventItem.All_Day_End__c) - new Date(eventItem.All_Day_Start__c)) / millisecondsPerDay));
		
		duration += 1;
		
		return "P" + duration + "D";
	}
	
	padItem(item) {
		return (item < 10) ? ('0' + item) : item.toString();
	}
	
}