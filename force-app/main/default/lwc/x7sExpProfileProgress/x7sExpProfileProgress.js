/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track, wire} from 'lwc';

import { NavigationMixin } from 'lightning/navigation';

import USER_ID from '@salesforce/user/Id';
import getUserById from '@salesforce/apex/x7sExpProfileProgressController.getUserById';

const PLACEHOLDER_PROFILE_PHOTO_PATH = 'profilephoto/005/';

export default class X7sExpProfileProgress extends NavigationMixin(LightningElement) {
	@api resultFormat = 'Actual Number';
	@api size = 150;
	@api strokeWidth = 8;
	@api strokeLineCap = 'butt';
	@api progressColor;
	@api remainingColor;
	@api thresholdPercent;
	@api thresholdColor;
	@api innerCircleColor;

	@api includeText;
	@api header;
	@api subHeader;
	@api description;
	@api linkText;
	@api linkUrl;

	@api customClass = '';

	@api
	get requiredFields() {
		return this._requiredFields;
	}
	set requiredFields(x) {
		this._requiredFields = x;
		this.fields = this._requiredFields
			.replace(/\s/g,'')
			.split(';')
			.filter( item => (item !== ''))
			.map( item => `${item}`);
	}

	@track haveUserData = false;
	@track completedFieldsCount = 0;
	@track totalFieldsCount = 0;
	@track fields = ['AboutMe', 'Email', 'SmallPhotoUrl'];
	
	@wire(getUserById, {userId: USER_ID, aboutMeFieldNameList: '$fields'})
	getUserData({error, data}) {
		if (data) {
			this.haveUserData         = true;
			this.completedFieldsCount = data;
			this.totalFieldsCount     = this.fields.length;
			
			this.error = undefined;
		} else if (error) {
			this.error = error;
		}
	}

	// - Value getters --------------------------------------------------------

	/**
	 * Returns an appropriate CSS classname list to define a component layout with
	 * or without header, subHeader, description and linkText/linkUrl, which is
	 * determined by the value of 'includeText'.
	 *
	 * @returns {string}
	 */
	get progressCircleClasses() {
		if (this.includeText) {
			return 'slds-size_1-of-1 slds-large-size_1-of-2 slds-align_absolute-center';
		} else {
			return 'slds-size_1-of-1 slds-large-size_1-of-1 slds-align_absolute-center';
		}
	}

	// - Callbacks and Event handlers -----------------------------------------

	/**
	 * Assumes an attribute of 'data-link' is available on the DOM element associated with the triggering event.
	 * Redirects the user to their profile page if 'data-link' has an empty string value - otherwise, assume that
	 * 'data-link' is a URL and redirect to it.
	 *
	 * The 'standard__recordPage' navigation method, when used with a @wire as we do in this component, causes a
	 * console logged error such as this:
	 *
	 *     Error: [LWC error]: Invalid event type "WireContextEvent" dispatched in element ... Event name must 1)
	 *     Start with a lowercase letter 2) Contain only lowercase letters, numbers, and underscores
	 *
	 * According to a SalesForce dev, this will be fixed in the future and can be ignored:
	 * https://github.com/salesforce/lwc/issues/1591#issuecomment-545988069
	 *
	 * @param event
	 */
	linkClick(event) {
		event.preventDefault();
		event.stopPropagation();

		const link = event.currentTarget.getAttribute('data-link');
		if (link === '') {
			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: USER_ID,
					objectApiName: 'User',
					actionName: 'view'
				}
			});
		} else {
			this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: link
				}
			});
		}
	}
}