/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import {api, LightningElement, wire} from 'lwc';
import LOCALE from '@salesforce/i18n/locale';
import CURRENCY from '@salesforce/i18n/currency';

import checkRSVPevents from '@salesforce/apex/x7sEventsListController.checkRSVPevents';
import getRSVPMemberAttendes from '@salesforce/apex/x7sEventsListController.getRSVPMemberAttendes';
import getRSVPAttendeeCount from '@salesforce/apex/x7sEventsListController.getRSVPAttendeeCount';
import createRSVPevents from '@salesforce/apex/x7sEventsListController.createRSVPevents';
import deleteRSVPevents from '@salesforce/apex/x7sEventsListController.deleteRSVPevents';

import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import labelNo from '@salesforce/label/c.x7sEventsRSVPButtonNotAttending';
import labelYes from '@salesforce/label/c.x7sEventsRSVPButtonAttending';
import labelWillNotAttend from '@salesforce/label/c.x7sEventsRSVPButtonWillNotAttend';
import labelTicketPrice from '@salesforce/label/c.x7sEventsLabelTicketPrice';
import labelBookEventTicket from '@salesforce/label/c.x7sEventsRSVPLabelBookEventTicket';

import {loadScript} from 'lightning/platformResourceLoader';
import EVENTSCUSTOM from '@salesforce/resourceUrl/x7sEventsCustom';

export default class X7sEventsDetailRSVP extends NavigationMixin(LightningElement) {
	
	@api recordId;
	@api variant = 'featured';
	@api peopleAttendText = 'Attending';
	@api willYouAttendText = 'Will you attend';
	@api variantSelected = 'neutral';
	@api variantUnselected = 'brand';
	@api customClass;
	@api listId = "ID_1";
	
	attendeeCount = 0;
	passedEvent = true;
	isPresentRSVP = false;
	error;
	isConCallbackExecuted = false;
	isAttendeeCount = false;
	notPassedEvent = false;
	isPaidEvent = false;
	
	event;
	
	labels = {
		labelNo,
		labelYes,
		labelWillNotAttend,
		labelTicketPrice,
		labelBookEventTicket
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		if (this.isConCallbackExecuted) {
			return;
		}
		loadScript(this, EVENTSCUSTOM + '/EventsCustom/moment.min.js');
		
		registerListener("geteventinfo", this.handleEventInfo, this);
		this.getRSVPMember();
		this.isConCallbackExecuted = true;
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get buttonVariant() {
		return this.isPresentRSVP ? this.variantSelected : this.variantUnselected;
	}
	
	get componentClass() {
		return `x7s-events-detail-rsvp ${this.customClass}`;
	}
	
	get eventPrice() {
		return new Intl.NumberFormat(LOCALE, {
			style: 'currency',
			currency: CURRENCY,
			currencyDisplay: 'symbol'
		}).format(this.event.Ticket_Price__c);
	}
	
	handleEventInfo(event) {
		if (this.listId === event.id) {
			let eventsListWrapper = event.value;
			
			let eventItem = eventsListWrapper.objEventList[0];
			var endDate = moment(eventItem.All_Day_Event__c ? eventItem.All_Day_End__c : eventItem.End_DateTime__c);
			if (endDate) {
				if (endDate.isBefore(moment({})))
					this.passedEvent = false;
			}
			
			this.notPassedEvent = this.passedEvent && eventItem.Enable_RSVP__c;
			this.isAttendeeCount = eventItem.Number_of_Attendees__c >= eventItem.RSVP_Count_Threshold__c;
			this.attendeeCount = eventsListWrapper.objEventList.length ? eventItem.Number_of_Attendees__c : 0;
			this.isPaidEvent = eventItem.Enable_Pricing_Payment__c;
			this.event = eventItem;
			
			this.checkRSVPevents();
		}
	}
	
	checkRSVPevents() {
		checkRSVPevents({
			EventId: this.recordId
		})
			.then(result => {
				this.isPresentRSVP = result;
			})
			.catch(error => {
				this.error = error;
				console.error("Error has occurred checking RSVP events:" + this.error);
			})
	}
	
	getRsvpCount() {
		getRSVPAttendeeCount({eventId: this.recordId})
			.then(result => {
				this.attendeeCount = result;
			})
			.catch(error => {
				this.error = error;
				console.error("Error has occurred getting events RSVP attendee count:" + this.error);
			})
	}
	
	handleAttendClick() {
		let attending = this.isPresentRSVP;
		// toggle attendance
		if (attending) {
			this.deleteRsvp();
		} else {
			this.createRsvp();
		}
	}
	
	createRsvp() {
		createRSVPevents({
			EventName: this.recordId,
			response: 'Yes'
		})
			.then(result => {
				this.getRSVPMember();
			})
			.catch(error => {
				this.error = error;
				console.error("Error occurred creating RSVP request:" + this.error);
			})
	}
	
	deleteRsvp() {
		deleteRSVPevents({
			EventId: this.recordId
		})
			.then(result => {
				this.getRSVPMember();
			})
			.catch(error => {
				this.error = error;
				console.error("Error occurred while deleting RSVP request:" + this.error);
			})
	}
	
	getRSVPMember() {
		getRSVPMemberAttendes({EventName: this.recordId})
			.then(data => {
				this.isPresentRSVP = data;
				this.getRsvpCount();
			})
			.catch(error => {
				this.error = error;
				console.error("Error has occurred RSVP member attendes for events:" + JSON.stringify(this.error));
			})
	}
	
	navigateToPaymentURL() {
		console.log("Payment_URL__c:" + this.event.Payment_URL__c);
		this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.event.Payment_URL__c
				}
			},
			false
		);
	}
}