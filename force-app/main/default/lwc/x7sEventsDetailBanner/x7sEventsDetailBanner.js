/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
*/
import {LightningElement ,api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {inLexMode} from 'c/x7sShrUtils';
import {constants} from 'c/x7sEventsBase';

import isRecordEditable from '@salesforce/apex/x7sEventsListController.isRecordEditable';
import getEventRecord from '@salesforce/apex/x7sEventsListController.getEventRecord';
import getSitePrefix from '@salesforce/apex/x7sEventsListController.getSitePrefix';

import labelEvents from "@salesforce/label/c.x7sEventsDetailTitle";
import labelEditEvent from "@salesforce/label/c.x7sEventsDetailTextEditEvent";
import labelEditVolOpportunities from "@salesforce/label/c.x7sEventsDetailTextEditVolunteerOpties";
import labelModalClose from "@salesforce/label/c.x7sEventsDetailLabelClose";
import labelVolOpportunities from "@salesforce/label/c.x7sEventsDetailVolunteerOpportunities";

export default class X7sEventsDetailBanner extends NavigationMixin(LightningElement) {

    @api exploreOtherEventsURL = "events-list";
    @api exploreOtherEvents = '';
    @api showTopics = "true";
    @api showVolunteerButton = false;
    @api editEventsUrl = "7s-events-create";
    @api recordId;
    @api customClass = "";
    @api variant = "featured";
    
    topics;
    @api eventTitle;
    eventsListWrapper;
    isEditable = false;
    numOfAttendees;
    displayNumOfAttendees;
    error;
    isEditVolunteers = false;
    sitePath;
    sitePrefix;

    labels = {
        labelEvents,
        labelEditEvent,
        labelEditVolOpportunities,
        labelModalClose,
        labelVolOpportunities
    }

    connectedCallback() {
        this.getSitePrefix();
        this.getEvents();
        this.checkIsRecordEditable();
    }

    get componentClass() {
		return `x7s-events-detail-banner ${this.customClass}`;
    }

    get showExploreEvent() {
        return (this.exploreOtherEventsURL && this.exploreOtherEventsURL.length) && (this.exploreOtherEvents && this.exploreOtherEvents.length);
    }

    get topicList() {
        return this.showTopics ? this.topics : '';
    }
    
    navigateToListView(){
        if (inLexMode()) {
            this[NavigationMixin.Navigate]({
                  type: 'standard__navItemPage',
                  attributes: {
                     apiName: this.exploreOtherEventsURL
                  }
               });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    pageName: this.exploreOtherEventsURL
                }
            });
        }
    }

    getSitePrefix(){
        getSitePrefix()
        .then(result => {
            let sitePath = result;
            if(sitePath){
                let position = sitePath.lastIndexOf('/s');
                this.sitePrefix = sitePath.substring(0, position);
                this.sitePath = sitePath;
            }
        })
        .catch(error => {
            this.error = error;
        })
    }

    getEvents(){
        getEventRecord({eventRecordId : this.recordId, customFields : ''})
        .then(result => {
            let eventsListWrapper = result;
            for(let i=0 ; i<eventsListWrapper.objEventList.length; i++){
                let event = eventsListWrapper.objEventList[i];
                this.eventTitle=  event.Name;
                
                if(eventsListWrapper.isGuestUser ? false : !!eventsListWrapper.languageEnabled) {
                    if (event.Language__c !== eventsListWrapper.userLanguage) {
                        this.eventTitle = event.X7S_Event_Translation__r[0].Title__c;
                    }
                }
                
                event.topics1 = [];
                event.topics1.push(eventsListWrapper.eventsToTopicsMap[event.Id]);
                event.topics = [];
                
                if (event.topics1) {
                    for (let j = 0; j < event.topics1.length; j++) {
                        if (event.topics1[j] !== undefined) {
                            for (let jj = 0; jj < event.topics1[j].length; jj++) {
                                event.topics.push(event.topics1[j][jj]);
                            }
                        }
                    }
            
                    event.topics.sort((a,b) => {
                        const nameA = a.Topic.Name.toUpperCase(); // ignore upper and lowercase
                        const nameB = b.Topic.Name.toUpperCase(); // ignore upper and lowercase
                        if (nameA < nameB) {return -1;}
                        if (nameA > nameB) {return 1;}
                        // names must be equal
                        return 0;
                    });
                }
            }
            let eventData = eventsListWrapper.objEventList[0];
            this.displayNumOfAttendees = eventData.Enable_RSVP__c && eventData.Number_of_Attendees__c >= eventData.RSVP_Count_Threshold__c;
            this.numOfAttendees = eventData.Number_of_Attendees__c;
            this.topics = eventData.topics;
            this.eventsListWrapper = eventsListWrapper;
        })
        .catch(error=>{
            this.error = error;
            console.log("Error occurred while getting event list:"+JSON.stringify(error));
        })
    }

    checkIsRecordEditable(){
        isRecordEditable({
            eventRecordId : this.recordId
        })
        .then(result =>{
            this.isEditable = result;
        })
        .catch(error =>{
            this.error = error
            console.log("Error has occured checking isEditable:"+this.error);
        })
    }

    callEditPage(){
        let url = this.editEventsUrl;
        if (url) {
            const urlSet = inLexMode() ? constants.editLex : constants.editComm;
            if (inLexMode()) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__navItemPage',
                    attributes: {
                        apiName: url
                    },
                    state: {
                        [urlSet.editMode]       : true,
                        [urlSet.id]             : this.recordId
                    }
                });
            } else {
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        pageName: url
                    },
                    state: {
                        [urlSet.editMode]       : true,
                        [urlSet.id]             : this.recordId
                    }
                });
            }
        }
    }   

    callVolunteerPage(){
        this.isEditVolunteers = true;
    }

    closeVolunteerPage(){
        this.isEditVolunteers = false;
    }
}