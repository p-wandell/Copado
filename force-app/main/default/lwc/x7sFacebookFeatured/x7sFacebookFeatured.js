/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved..
 */

import {LightningElement, api, track} from 'lwc';

import getMetaData from '@salesforce/apex/x7sFacebookFeaturedController.getMetaData';

export default class X7SFacebookFeatured extends LightningElement {
    @api title = '';
    @api subTitle = '';
    @api align = 'center';

    @api moreText;
    @api moreLink;

    @api post1href;
    @api post1height;
    @api post1full;

    @api post2href;
    @api post2height;
    @api post2full;

    @api post3href;
    @api post3height;
    @api post3full;

    @api appId;
    @api useMetaData;
    @api record;
    @api variant = 'slds-card'; // default, slds-card, featured

    @track loading = false;

    metadataArray = [];
    debug = false;

    /**
     * Get Facebook Post 1
     * @returns {string} - url
     */
    get facebookPost1Href() {
        if (this.post1href && this.post1height) {
            return this.facebookHref(this.post1href, this.post1height, this.post1full);
        } else {
            return '';
        }
    }

    /**
     * Get Facebook Post 2
     * @returns {string} - url
     */
    get facebookPost2Href() {
        if (this.post2href && this.post2height) {
            return this.facebookHref(this.post2href, this.post2height, this.post2full);
        } else {
            return '';
        }
    }

    /**
     * Get Facebook Post 3
     * @returns {string} - url
     */
    get facebookPost3Href() {
        if (this.post3href && this.post3height) {
            return this.facebookHref(this.post3href, this.post3height, this.post3full);
        } else {
            return '';
        }
    }

    /**
     * Displays more link button when the text and link are filled
     * @returns {boolean}
     */
    get showMoreLink() {
        return !!(this.moreLink && this.moreText);
    }

    connectedCallback() {
        this.getMetaData();
    }

    /**
     * Assemble the Facebook embed URL
     * @param {string} url
     * @param {number} height
     * @param {boolean} full
     * @returns {string} - url
     */
    facebookHref(url, height, full) {
        const baseUrl = 'https://www.facebook.com/plugins/post.php';
        const postUrl = `?href=${url}`;
        const widthStr = `&width=auto`;
        const heightStr = `&height=${height}`;
        const showText = `&show_text=${full}`;
        const appId = this.appId ? `&appId=${this.appId}` : '';

        return baseUrl + postUrl + showText + widthStr + heightStr + appId;
    }

    /**
     * If useMetaData, go grab the metadata and assign it to the post href vars
     */
    getMetaData() {
        if (this.useMetaData && this.record) {
            this.loading = true;
            getMetaData({recordLabel: this.record})
                .then(response => {
                    this.metadataArray = response.split(',');

                    if (this.metadataArray.length > 0) {
                        this.post1href = this.metadataArray[0];
                    }

                    if (this.metadataArray.length > 1) {
                        this.post2href = this.metadataArray[1];
                    }

                    if (this.metadataArray.length > 2) {
                        this.post3href = this.metadataArray[2];
                    }
                })
                .catch(error => {
                    if (this.debug) {
                        console.error('getMetaData', error);
                    }
                })
                .finally(() => {
                    this.loading = false;
                });
        }
    }
}