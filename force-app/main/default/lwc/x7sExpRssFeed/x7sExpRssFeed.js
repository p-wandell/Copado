/*
 * Copyright (c) 2020. 7Summits Inc.
 */


import {LightningElement, track, api} from 'lwc';

import {showToast, stringifyThrownLdsError} from 'c/x7sShrUtils';

import getRSSFeedList from '@salesforce/apex/x7sExpRSS.getRSSFeedList';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';

export default class X7sExpRssFeed extends LightningElement {
	feedItems = [];
	loading = false;
	@api debug;

	@api customClass = '';
	@api variant = 'default'; // default, slds-card, featured
	@api title = '';
	@api titleAlign = 'left'; // left, center, right
	@api description = '';
	@api iconName = '';

	@api feedUrlEndpoint = '';
	@api feedRecordsToShow;

	@api listEmptyText;
	@api listErrorText;

	@track listIsEmpty;
	label = {labelAriaWrapper};

	// - Callbacks and Event handlers -----------------------------------------

	/**
	 * Gets the initial feed once the component has connected
	 */
	connectedCallback() {
		this.getFeed();
	}

	// - Core method ----------------------------------------------------------

	/**
	 * Fetch a well formed RSS feed from a remote source. A proper remote site
	 * setting record must exist for the URL in Salesforce.
	 *
	 * It is assumed that 'publishDate' values are proper RFC 2822 formatted dates,
	 * as per the RSS specification. Presentation of the date/time will be
	 * suppressed if the date is not parsable.
	 */
	getFeed() {
		this.responseText = '';
		this.listIsEmpty = true;

		if (this.feedUrlEndpoint.startsWith('http' || 'www') ) {
			this.loading = true;
			getRSSFeedList({
				rssFeedEndpoint: this.feedUrlEndpoint,
				recordsToShow: this.feedRecordsToShow
			}).then(response => {
				this.feedItems = response.map(item => ({
					...item,
					publishTimestamp: item.publishDate ? Date.parse(item.publishDate) : ''
				}));
				if (this.feedItems != null && this.feedItems.length > 0) {
					this.listIsEmpty = false;
				} else {
					showToast(
						'No Items Found In Feed',
						this.listEmptyText,
						'warning',
						'dismissable'
					);
				}
				this.loading = false;
			}).catch(error => {
				showToast(
					'Failed to Load Feed',
					this.listErrorText,
					'error',
					'dismissable'
				);
				// If debug mode is on display console.log
				if(this.debug) {
					console.log('Failed with state: ', stringifyThrownLdsError(error));
				}
				this.loading = false;
			});
		}
	}
}