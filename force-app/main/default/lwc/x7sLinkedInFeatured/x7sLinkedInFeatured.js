/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import {guid} from 'c/x7sShrUtils';

import getMetaData from '@salesforce/apex/x7sLinkedInFeaturedController.getMetaData';

export default class X7SLinkedInFeatured extends LightningElement {
    @api title = '';
    @api subTitle = '';
    @api align = 'center';

    @api moreText;
    @api moreLink;

    @api postIdsList = '';
    @api postsPerRow = '3';
    @api postHeight = 550;

    @api useMetaData = false;
    @api record;
    @api variant = 'slds-card'; // default, slds-card, featured
    @api ariaComponentWrapperLabel = 'LinkedIn posts container';
    @api ariaPostTitleLabel = 'LinkedIn Post';
    @api ariaUniqueIdLabel = 'Unique Id'

    @track loading = false;
    @track posts = [];

    metadataArray = [];
    debug = false;
    postCounter = 0;
    navigationLandmarkAriaLabel;
    componentGuid = guid();

    /**
     * Set responsive grid rows
     * @returns {string}
     */
    get rowClass() {
        return `slds-col slds-size_1-of-1 slds-medium-size_1-of-${this.postsPerRow}`;
    }

    /**
     * Displays more link button when the text and link are filled
     * @returns {boolean}
     */
    get showMoreLink() {
        return !!(this.moreLink && this.moreText);
    }

    connectedCallback() {
        this.navigationLandmarkAriaLabel = `${this.ariaComponentWrapperLabel} (${this.ariaUniqueIdLabel} ${this.componentGuid})`;
        if (this.useMetaData && this.record) {
            // Use metadata
            this.getMetaData();
        } else if (this.postIdsList) {
            // Use builder data
            const posts = this.postIdsList.split(',');
            posts.forEach((e) => {
                this.setPostsArray(e);
            });
        }
    }

    /**
     * Set up the array to iterate through.
     * @param id
     */
    setPostsArray(id) {
        let data = {};
        data.url = `https://www.linkedin.com/embed/feed/update/${id}`;
        data.guid = guid();
        data.uniquePostTitleForScreenReader = `${this.ariaPostTitleLabel} ${++this.postCounter} (${this.ariaUniqueIdLabel} ${data.guid})`;

        this.posts.push(data);
    }

    /**
     * If useMetaData, go grab the metadata and assign it to the post href vars
     */
    getMetaData() {
        this.loading = true;
        getMetaData({recordLabel: this.record})
            .then(response => {
                if (response) {
                    this.metadataArray = response.split(',');

                    if (this.metadataArray.length) {
                        this.metadataArray.forEach(id => {
                            this.setPostsArray(id);
                        });
                    }
                } else {
                    console.error('No metadata found for that record name.');
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