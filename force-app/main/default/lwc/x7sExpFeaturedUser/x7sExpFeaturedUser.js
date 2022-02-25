/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';

// schema
import NAME from '@salesforce/schema/User.Name';
import TITLE from  '@salesforce/schema/User.Title';
import COMMUNITY_NICKNAME from '@salesforce/schema/User.CommunityNickname';
import MEDIUM_PHOTO_URL from  '@salesforce/schema/User.MediumPhotoUrl';

export default class X7sExpFeaturedUser extends NavigationMixin(LightningElement) {

    @api title = 'Featured User';
    @api titleAlignment = 'left';
    @api viewProfileLabel = 'View Profile';
    @api recordId;
    @api intro;
    @api ctaText;
    @api ctaLink;
    @api displayType = 'Plain';
    @api customClass;

    @track name;
    @track userTitle;
    @track communityNickname;
    @track mediumPhotoUrl;
    @track error;

    /**
     * Get user information from LDS
     * @param error
     * @param data
     */
    @wire(getRecord, {
        recordId: '$recordId',
        fields: [NAME, TITLE, COMMUNITY_NICKNAME, MEDIUM_PHOTO_URL]
    })
    wiredUserRecord({ error, data }) {
        if (data) {
            // console.log('wiredUserRecord() data', data);
            this.name = getFieldValue(data, NAME);
            this.communityNickname = getFieldValue(data, COMMUNITY_NICKNAME);
            this.userTitle = getFieldValue(data, TITLE);
            this.mediumPhotoUrl = getFieldValue(data, MEDIUM_PHOTO_URL);
            this.error = undefined;
        } else if (error) {
            console.log('wiredUserRecord() error', error);
            this.error = error;
        }
    }

    /**
     * return SLDS alignment class and any additional SLDS or CSS class(es) on <section> element
     * @returns {string}
     */
    get componentClass() {
        const displayType = this.displayType.toLowerCase();
        return `${displayType} ${this.customClass}`;
    }
}