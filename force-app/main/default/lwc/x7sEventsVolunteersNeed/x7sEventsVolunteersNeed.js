/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import { LightningElement,api } from 'lwc';

import labelTaskSignup from '@salesforce/label/c.x7sEventsVolunteerNeedLabelTaskSignup';
import labelVolunteering from '@salesforce/label/c.x7sEventsVolNeedAlreadySignedUp';
import labelMoreVolunteersNeeded from '@salesforce/label/c.x7sEventsVolNeedMoreVolunteersNeeded';
import labelSignUp from '@salesforce/label/c.x7sEventsVolNeedLabelSignUp';
import labelYoureSignedup from '@salesforce/label/c.x7sEventsVolNeedAlreadySignedUp';
import labelRemoveMe from '@salesforce/label/c.x7sEventsVolNeedButtonRemoveMe';
import labelshowless from '@salesforce/label/c.x7sEventsVolNeedButtonShowLess';
import labelshowMore from '@salesforce/label/c.x7sEventsVolNeedButtonShowMore';

import removeVolunteer from '@salesforce/apex/x7sEventsVolunteersController.removeVolunteerSingle';
import registerVolunteerSingle from '@salesforce/apex/x7sEventsVolunteersController.registerVolunteerSingle';

export default class X7sEventsVolunteersNeed extends LightningElement {

    @api wrapper;
    @api currentUser;
    @api sitePath;
    
    showXUsers = 18;
    volunteersNeeded = 0;
    isSelected = true;
    currentUserRegistrationRecord = {};
    showingMore = false;

    labels = {
        labelVolunteering,
        labelMoreVolunteersNeeded,
        labelTaskSignup,
        labelSignUp,
        labelYoureSignedup,
        labelRemoveMe,
        labelshowless,
        labelshowMore
    }

    connectedCallback(){

        // Compute current needs and sort user to front (if this user is already signed up)
        this.calculateVolunteersNeeded();
        this.sortCurrentUserToFront();

        // Create listing for currently logged in user (to assign to front if user wasn't already registered... that way it's easy to toggle and display without another full server call for results)
        this.establishCurrentUserRecord();
        this.apendIndexInRegistrations();
    }

    get showSignUpBtn(){
        return this.currentUser.UserType != 'Guest' && (this.wrapper.currentUserRegistered || this.volunteersNeeded > 0);
    }

    get showVolNeededcount(){
        return this.volunteersNeeded != 999999;
    }

    get showVolRegisteredcount(){
        let registeredUsers = this.wrapper.volunteerNeed.Volunteer_Registrations__r;
        return registeredUsers && registeredUsers.length>0;
    }

    get showMorebtn(){
        let registrations = this.wrapper.volunteerNeed.Volunteer_Registrations__r;
        return registrations && registrations.length ? registrations.length > this.showXUsers : false;
    }

    calculateVolunteersNeeded(){
        var wrapper = this.wrapper;
        var volunteersNeeded = wrapper.volunteerNeed.Volunteers_Needed__c;
        var effectiveVolunteersNeeded = volunteersNeeded;

        //this is a no-limit task
        if (volunteersNeeded == 999999) {
            effectiveVolunteersNeeded = volunteersNeeded;
        } else if (typeof wrapper.volunteerNeed.Volunteer_Registrations__r !== 'undefined') {
            effectiveVolunteersNeeded = volunteersNeeded - wrapper.volunteerNeed.Volunteer_Registrations__r.length;
        }
        this.volunteersNeeded = effectiveVolunteersNeeded;
    }

    sortCurrentUserToFront(){
        var wrapper = this.wrapper;
        var currentUser =this.currentUser;
        var reordedArray = [];

        // Loop through all registrants
        if (wrapper.currentUserRegistered){
            for (var x = 0;x<wrapper.volunteerNeed.Volunteers_Registered__c;x++){
                //If current registrant = current user (and isn't already first user)
                if (wrapper.volunteerNeed.Volunteer_Registrations__r[x].User__r.Id == currentUser.Id && x>0)
                    reordedArray.splice(0,0,wrapper.volunteerNeed.Volunteer_Registrations__r[x]);
                else
                    reordedArray.push(wrapper.volunteerNeed.Volunteer_Registrations__r[x]);
            }
            let tempWrapper = JSON.parse(JSON.stringify(wrapper));
            tempWrapper.volunteerNeed.Volunteer_Registrations__r = reordedArray;
            this.wrapper = tempWrapper;
        }
    }

    // Create ghost registration record for user. This is easier to use when the user adds / removes registrations
    establishCurrentUserRecord(){
        var currentUser = this.currentUser;

        this.currentUserRegistrationRecord.User__r = {
            Id : currentUser.Id,
            Name: '' ,
            SmallPhotoUrl: currentUser.SmallPhotoUrl
        };
    }

    removeVolunteer(){
        let wrapper = this.wrapper;

        removeVolunteer({
            needId : wrapper.volunteerNeed.Id
        })
        .then(result => {
            if(result){
                let tempWrapper = JSON.parse(JSON.stringify(wrapper));
                tempWrapper.currentUserRegistered = false;
                tempWrapper.volunteerNeed.Volunteer_Registrations__r.splice(0,1);
                this.wrapper = tempWrapper;

                this.calculateVolunteersNeeded();
                this.apendIndexInRegistrations();
            }
        })
        .catch(error => {
            console.log("Error Ocuured while removing volunteer"+error);
        })
    }

    registerVolunteer(){
        let wrapper = this.wrapper;
        registerVolunteerSingle({
            needId : wrapper.volunteerNeed.Id
        })
        .then(result => {
            let tempWrapper = JSON.parse(JSON.stringify(wrapper));
            tempWrapper.currentUserRegistered = true;
            if(tempWrapper.volunteerNeed.Volunteer_Registrations__r === undefined)
                tempWrapper.volunteerNeed.Volunteer_Registrations__r = [];
            tempWrapper.volunteerNeed.Volunteer_Registrations__r.splice(0,0,this.currentUserRegistrationRecord);
            this.wrapper = tempWrapper;

            this.calculateVolunteersNeeded();
            this.apendIndexInRegistrations();
        })  
        .catch(error => {
            console.log("Error occurred while registering volunteer:"+error);
        })
    }

    apendIndexInRegistrations(){
        let wrapper = this.wrapper;
        let tempWrapper = JSON.parse(JSON.stringify(wrapper));
        if(tempWrapper.volunteerNeed.Volunteer_Registrations__r && wrapper.volunteerNeed.Volunteer_Registrations__r.length){
            for(let i=0; i<tempWrapper.volunteerNeed.Volunteer_Registrations__r.length ; i++){
                tempWrapper.volunteerNeed.Volunteer_Registrations__r[i].showAvatar = (i <= this.showXUsers) || this.showingMore;
                if(tempWrapper.volunteerNeed.Volunteer_Registrations__r[i].showAvatar)
                    tempWrapper.volunteerNeed.Volunteer_Registrations__r[i].avatarLink = this.sitePath + '/profile/' + tempWrapper.volunteerNeed.Volunteer_Registrations__r[i].User__r.Id;
            }
            this.wrapper = tempWrapper;
        }
    }
    showToggle(){
        this.showingMore = !this.showingMore;
    }
}