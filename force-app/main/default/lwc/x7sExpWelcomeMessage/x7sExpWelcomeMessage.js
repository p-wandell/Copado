/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track, wire} from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import {formatText} from "c/x7sShrUtils";

import USER_ID from '@salesforce/user/Id';
import IS_GUEST from '@salesforce/user/isGuest';
import FIRST_NAME from '@salesforce/schema/User.FirstName';
import COMMUNITY_NICKNAME from '@salesforce/schema/User.CommunityNickname';
import COMPANY_NAME from '@salesforce/schema/User.CompanyName';
import CONTACT_NAME from '@salesforce/schema/User.Contact.Name';
import CONTACT_FIRST_NAME from '@salesforce/schema/User.Contact.FirstName';
import ACCOUNT_NAME from '@salesforce/schema/User.Contact.Account.Name';
import TIME_ZONE from '@salesforce/i18n/timeZone';

export default class X7sExpWelcomeMessage extends LightningElement {

    @api greeting = 'Welcome back, {0}!';
    @api greetingMorning = 'Good morning, {0}.';
    @api greetingAfternoon = 'Good afternoon, {0}.';
    @api greetingEvening = 'Good evening, {0}.';
    @api useCommunityNickname = false;
    @api showAccountName = false;
    @api guestGreeting = 'Welcome to the Community.';
    @api welcomeText = 'Welcome message here.';
    @api customClass;

    @track isGuest = IS_GUEST;
    @track firstName;
    @track communityNickname;
    @track companyName;
    @track contactName;
    @track contactFirstName;
    @track accountName;

    debug = false;

    /**
     * Get user's first name, contact first name and account name for active user
     * @param error
     * @param data
     */
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [FIRST_NAME, COMMUNITY_NICKNAME, COMPANY_NAME, CONTACT_NAME, CONTACT_FIRST_NAME, ACCOUNT_NAME],
    })
    wiredContactRecord({ error, data }) {
        if (data) {
            this.firstName = getFieldValue(data, FIRST_NAME);
            this.communityNickname = getFieldValue(data, COMMUNITY_NICKNAME);
            this.contactName = getFieldValue(data, CONTACT_NAME);
            this.contactFirstName = getFieldValue(data, CONTACT_FIRST_NAME);
            this.companyName = getFieldValue(data, COMPANY_NAME);
            this.accountName = getFieldValue(data, ACCOUNT_NAME);

            if (this.debug) {
                console.log('wiredContactRecord() data', data);
            }
        } else if (error && this.debug) {
            console.error('wiredContactRecord() error', error);
        }
    }

    /**
     * Check which name fields are set. Prioritizing FIRST_NAME.
     * If 'useCommunityNickname' = true, then use COMMUNITY_NICKNAME.
     * @returns {string} name
     */
    getName() {
        let name = this.contactName ? this.contactName : '';
        name = this.contactFirstName ? this.contactFirstName : name;
        name = this.firstName ? this.firstName : name;
        if (this.useCommunityNickname) {
            name = this.communityNickname ? this.communityNickname : name;
        }
        return name;
    }

    /**
     * if 'showAccountName' = true,
     * check if the user has an account, return the account name;
     * otherwise return the company name on the user record
     * @returns {string} account or company name
     */
    accountCompanyName() {
        const name = this.accountName ? this.accountName : this.companyName;
        if (name) {
            return this.showAccountName ? ` (${name})` : ``;
        } else {
            return '';
        }
    }

    /**
     * formats all greetings with text + first name; returns localized or default greeting
     * @returns {string} localized greeting based on user's Salesforce timezone
     */
    localizedGreeting() {
        let greeting = formatText(this.greeting, this.getName()); // default greeting
        let currentUsersTime = new Date().toLocaleString("en-US", {timeZone: TIME_ZONE});
        let currentUserHour = new Date(currentUsersTime).getHours();

        // only return a localized greeting if we have the user's timezone
        if(TIME_ZONE) {
            if (currentUserHour < 12) {
                greeting = this.greetingMorning ? formatText(this.greetingMorning, this.getName()) : greeting;
            } else if (currentUserHour < 18) {
                greeting = this.greetingAfternoon ? formatText(this.greetingAfternoon, this.getName()) : greeting;
            } else {
                greeting = this.greetingEvening ? formatText(this.greetingEvening, this.getName()) : greeting;
            }
        }

        return greeting;
    }

    /**
     * @returns {string} template literal with <h1></h1> and guestGreeting
     */
    get guestMessage() {
        return `<h1>${this.guestGreeting}</h1>`;
    }

    /**
     * wait until wired data returns a name to prevent FOUC (flash of undefined content)
     * once we have the nickname, check if the user has a name set; show guestGreeting if there is no name
     * @returns {string} template literal with <h1></h1> and full welcome message + account or company name
     */
    get welcomeMessage() {
        return this.getName() ? (this.getName() ? `<h1>${this.localizedGreeting()} ${this.accountCompanyName()}</h1>` : `<h1>${this.guestGreeting}</h1>`) : ``;
    }

}