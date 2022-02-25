/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getMyFollowedTopics from '@salesforce/apex/x7sExpTopicsFollowedController.getMyFollowedTopics'

import { stringifyThrownLdsError } from 'c/x7sShrUtils';

export default class X7sExpTopicsFollowed extends NavigationMixin(LightningElement) {
	@api title = 'Topics I Follow';
	@api recordsToShow = '10';
    @api showNoTopicsMessage;
    @api noTopicsTitle = 'Topics I Follow';
    @api noTopicsMessage = "You aren't following any topics. Follow some community topics and you will see them here.";
    @api noTopicsButtonLabel = 'Follow Topics';
    @api noTopicsButtonLink = '/topiccatalog';
	@api customClass;

	@track isLoading = false;
	@track followedTopics = [];

	// - Value getters --------------------------------------------------------

    get hasFollowedAnyTopics() {
    	return this.followedTopics.length > 0;
	}

	get showIfNoTopicsFollowed() {
    	return this.showNoTopicsMessage && !this.isLoading;
	}

	get showNoTopicsButton() {
    	return this.noTopicsButtonLink && this.noTopicsButtonLabel;
	}

	get hasFollowedTopicsComponentClasses() {
		return `x7s-featured-topics ${this.customClass}`.trim();
	}

	get hasFollowedNoTopicsComponentClasses() {
		return `x7s-featured-topics e7x-featured-topics_message slds-box ${this.customClass}`.trim();
	}

	// - Callbacks and Event handlers -----------------------------------------

    connectedCallback() {
    	this.isLoading = true;
		getMyFollowedTopics({
			recordsToShow: this.recordsToShow
		})
			.then(response => {
				this.isLoading = false;
				this.followedTopics = response;
			})
			.catch(error => {
				this.isLoading = false;
				console.log('Failed with state: ', stringifyThrownLdsError(error));
			});
    }

	/**
	 * Use lightning/navigation service to navigate to a
	 * record page (a "Topic") using the recordId
	 * provided in 'value'.
	 *
	 * @param event
	 */
	navigateToTopic(event) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.currentTarget.value,
				actionName: 'view'
			},
		});
    }

	/**
	 * Use lightning/navigation service to navigate to URL
	 * provided in 'value'.
	 *
	 * @param event
	 */
	navigateToLink(event) {
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: event.currentTarget.value,
				actionName: 'view'
			},
		});
	}
}