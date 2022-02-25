/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import { LightningElement,api } from 'lwc';

import getEventVolunteerNeeds from '@salesforce/apex/x7sEventsVolunteersController.getEventVolunteerNeeds';
import getSitePrefix from '@salesforce/apex/x7sEventsVolunteersController.getSitePrefix';
import getCurrentUser from '@salesforce/apex/x7sEventsVolunteersController.getCurrentUser';

import labelGuestUserVolunteerAction from '@salesforce/label/c.x7sEventsVolunteerGuestUserAction';
import labelLoginRegister from '@salesforce/label/c.x7sEventsVolunteerLoginRegister';

export default class X7sEventsVolunteers extends LightningElement {

    @api recordId;
    @api customClass;
    @api variant = 'featured';

    volunteerNeeds = [];
    sitePath;
    sitePrefix;
    currentUser;
    isInit = false;
    volunteerNeedsdesc;
    isSelected = true;

    labels = {
        labelLoginRegister,
        labelGuestUserVolunteerAction,
    }

    connectedCallback(){
        this.get_SitePrefix();
        this.getCurrentUser();
    }

    get isvolunteerNeeds(){
        return this.isInit && this.volunteerNeeds.length>0;
    }

    get isGuestUser(){
        return this.currentUser.UserType == 'Guest';
    }

    get loginPath(){
        return this.sitePath + '/login';
    }

    get_SitePrefix(){
        getSitePrefix()
        .then(result => {
            var sitePath = result;
            this.sitePath = sitePath;
            this.sitePrefix = sitePath.replace("/s", "");
        })
        .catch(error => {
            console.log("Error occurred getting siteprefix:"+error);
        })
    }

    getCurrentUser(){
        getCurrentUser()
        .then(result => {
            this.currentUser = result;
            this.getEventVolunteerNeeds();
        })
        .catch(error => {
            console.log("Error occurred getting Current User:"+error);
        })
    }

    getEventVolunteerNeeds(){
        getEventVolunteerNeeds({
            eventIdString : this.recordId
        })
        .then(result => {
            let volunteerNeeds = result;
            if(volunteerNeeds && volunteerNeeds.length){
                for(let i=0 ; i<volunteerNeeds.length ; i++){
                    let volunteers = volunteerNeeds[i];
                    this.volunteerNeedsdesc = volunteerNeeds[i].volunteerNeed.Event__r.Volunteer_Description__c;

                    volunteers.volunteerNeed.hasRegisteredVol   = volunteers.volunteerNeed.Volunteers_Registered__c > 0 ? true : false;
                    volunteers.volunteerNeed.hasNeededVolCount  = volunteers.volunteerNeed.Volunteers_Needed__c != 999999 ? true : false;
                }
            }
            this.volunteerNeeds = volunteerNeeds;
            this.isInit = true;
        })
        .catch(error => {
            console.log("Error occurred getting Event Volunteer Needs:"+error);
        })
    }
}