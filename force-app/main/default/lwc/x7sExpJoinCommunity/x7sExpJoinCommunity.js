/*
 * Copyright (c) 2020. 7Summits Inc.
 */


import { LightningElement, api, wire } from 'lwc';

import getUsersWithPublicPhotos from '@salesforce/apex/x7sExpJoinCommunityController.getUsersWithPublicPhotos'

export default class X7sExpJoinCommunity extends LightningElement {
    @api title = 'Have you joined our online community?';
    @api titleAlignment = 'center';
    @api boldText = 'Hello there!';
    @api plainText = 'Join the community!';
    @api ctaText = 'Learn More';
    @api ctaLink = 'http://example.com';
    @api customClass = '';

    @wire(getUsersWithPublicPhotos, { desiredResultsCount: 7 })
        users;

    // - Value getters --------------------------------------------------------

    /**
     * return SLDS padding class and any additional SLDS or CSS class(es) on <section> element
     * @returns {string}
     */
    get componentClass() {
        return `slds-p-around_x-large ${this.customClass}`.trim();
    }
}