/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import EventsResource from '@salesforce/resourceUrl/x7sEventsCustom';

import {events, saveViewState, constants, custom} from 'c/x7sEventsBase';

import labelTo from '@salesforce/label/c.x7sEventsFilterLabelToDate';
import labelGroup from '@salesforce/label/c.x7sEventsCreateTitleLimitToSpecificGrps';

export default class X7sEventsListItem extends NavigationMixin(LightningElement) {

    @api event;
    @api layout = 'vertical';
    @api showImages = false;
    @api useAvatar = false;
    @api tileVariant = 'default';
    @api textAlign = 'center';
    @api sitePrefix;
    @api showEventType;
    @api showTopics = "true";
    @api eventsListWrapper;
    @api filterOn;
    @api listSize;
    @api totalEvents;
    @api numberofresults;
    @api limitToSpecificGroups = false;
    @api customLabel1;
    @api customField1;
    @api customLabel2;
    @api customField2;
    @api customLabel3;
    @api customField3;
    @api listViewMode;

    attachmentPath;

    labels = {
        labelTo,
        labelGroup
    }

    connectedCallback() {
        if(this.listViewMode === 'List') {
            this.persistListView();
        } else if(this.listViewMode === 'Tile') {
            this.persistTileView();
        }
    }

    get eventName() {
        if(this.eventsListWrapper.isGuestUser ? false : !!this.eventsListWrapper.languageEnabled){
            if(this.event.Language__c !== this.eventsListWrapper.userLanguage) {
                return this.event.X7S_Event_Translation__r[0].Title__c;
            } else {
                return this.event.Name;
            }
        }
        else {
            return this.event.Name;
        }
    }

    get location() {
        if(this.eventsListWrapper.isGuestUser ? false : !!this.eventsListWrapper.languageEnabled){
            if(this.event.Language__c !== this.eventsListWrapper.userLanguage) {
                return this.event.X7S_Event_Translation__r[0].Location_Name__c;
            }
            else {
                return this.event.Location_Name__c;
            }
        }
        else {    
            return this.event.Location_Name__c;
        }
    }

    get imageUrl() {
        this.attachmentPath = this.sitePrefix + custom.ATTACHMENT_PATH;
        let images = this.event.Attachments;
        let imageURL = this.event.imageURL;
        if(this.showImages) {
            if(this.event.Image_Type__c !== constants.imageTypes.NONE) {
                if(imageURL != undefined && this.event.Image_Type__c !== constants.imageTypes.ATTACHMENT) {
					return imageURL;
				} else if(images) {
                    return this.attachmentPath + this.event.Attachments[0].Id;
                } 
            }
            return `${EventsResource}` + '/EventsCustom/images/default-events.png';
        }
        return '';
    }

    get hideImage() {
        return !this.showImages;
    }

    get timeZone() {
        return this.event.All_Day_Event__c === true ? 'UTC': this.eventsListWrapper.strTimeZone;
    }

    get isNotAllDayEvent() {
        return this.event.All_Day_Event__c === false;
    }

    get customField1Value() {
        return this.customField1 && this.customField1.length > 0;
    }

    get customField2Value() {
        return this.customField2 && this.customField2.length > 0;
    }

    get customField3Value() {
        return this.customField3 && this.customField3.length > 0;
    }

    get displayNumOfAttendees() {
        return this.event.Enable_RSVP__c && this.event.Number_of_Attendees__c >= this.event.RSVP_Count_Threshold__c;
    }

    get topics() {
        return this.showTopics ? this.event.topics : '';
    }

    persistListView() {
        saveViewState(events.listViewMode.List);
    }

    persistTileView() {
        saveViewState(events.listViewMode.Tile);
    }

    navigateToGroup() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.event.GroupId__c,
                objectApiName: 'Group',
                actionName: 'view'
            }
        });
    }
}