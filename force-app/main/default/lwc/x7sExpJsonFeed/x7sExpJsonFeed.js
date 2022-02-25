/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, track, api} from 'lwc';

import {showToast, stringifyThrownLdsError} from 'c/x7sShrUtils';

import getJSONFeed from '@salesforce/apex/x7sExpJSONFeedController.getJSONFeed';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';


export default class X7sExpJsonFeed extends LightningElement {
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
	@api feedType; // 'Test', 'Blog' or 'Events' - Apex expects title-case-sensitive

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
	 * Gets the JSON Feed based upon data passed in from the builder configuration
	 * Parses JSON items and builds the feed
	 */
	getFeed() {
		this.listIsEmpty = true;

		if (this.feedUrlEndpoint.startsWith('http' || 'www') ) {
			this.loading = true;
			getJSONFeed({
				endpointUrl: this.feedUrlEndpoint,
				recordsToShow: this.feedRecordsToShow,
				feedType: this.feedType
			}).then(response => {
				if (response.hasOwnProperty('responseCode')
					&& response.responseCode === 200
					&& response.hasOwnProperty('responseBody')) {
					switch (this.feedType) {
						case 'Blog':
							this.feedItems = this.prepareBlogRecords(
								JSON.parse(response.responseBody)
							);
							break;
						case 'Events':
							this.feedItems = this.prepareEventsRecords(
								JSON.parse(response.responseBody)
							);
							break;
						default:
							this.feedItems = this.prepareTestRecords(
								JSON.parse(response.responseBody)
							);
					}
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
				} else {
					showToast(
						'Failed to Load Feed',
						this.listErrorText,
						'error',
						'dismissable'
					);
					this.loading = false;
				}
			}).catch(error => {
				showToast(
					'Failed to Load Feed',
					this.listErrorText,
					'error',
					'dismissable'
				);
				if (this.debug) {
					console.log('Failed with state: ', stringifyThrownLdsError(error));
				}
				this.loading = false;
			});
		}
	}

	// - Prepare Records --------------------------------------------------

	/**
	 * x7sExpJSONFeedController.getJSONFeed returns a single object, not an array, for
	 * a feed type of 'Test' - make sure it is an array in the end.
	 * @param serializedResponse
	 * @returns {[*]}
	 */
	prepareTestRecords (serializedResponse) {
		return [{
			...serializedResponse,
			Id: '7s-test-rec',
			eventTimestamp: serializedResponse.hasOwnProperty('dateTimeField') ? Date.parse(serializedResponse.dateTimeField) : ''
		}];
	}

	/**
	 * Expecting a JSON response payload from a WordPress REST API "Posts" request.
	 * Prepare for 'events' style presentation.
	 * @param serializedResponse
	 * @returns {[*]}
	 */
	prepareEventsRecords (serializedResponse) {
		return serializedResponse
			.slice(0, this.feedRecordsToShow)
			.map(item => ({
				...item,
				Id: item.id,
				eventTimestamp: item.hasOwnProperty('date') ? Date.parse(item.date) : ''
			}));
	}

	/**
	 * Expecting a JSON response payload from a WordPress REST API "Posts" request
	 * Prepare for 'blog' article style presentation.
	 * @param serializedResponse
	 * @returns {[*]}
	 */
	prepareBlogRecords (serializedResponse) {
		return serializedResponse
			.slice(0, this.feedRecordsToShow)
			.map(item => ({
				...item,
				Id: item.id,
				publishTimestamp: item.date ? Date.parse(item.date) : ''
			}));
	}

	// - Value getters --------------------------------------------------------

	/**
	 * Determines if the feedType is a test
	 * @returns {boolean}
	 */
	get feedTypeIsTest() {
		return this.feedType === 'Test';
	}

	/**
	 * Determines if the feed type is a blog
	 * @returns {boolean}
	 */
	get feedTypeIsBlog() {
		return this.feedType === 'Blog';
	}

	/**
	 * Determines if the feed type is events
	 * @returns {boolean}
	 */
	get feedTypeIsEvents() {
		return this.feedType === 'Events';
	}
}