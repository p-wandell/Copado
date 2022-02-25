/**
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelAccordion';

export default class x7sExpAccordion extends LightningElement {
	@api label;
	@api content;
	@api
	get isOpen() {
		return this._isOpen;
	}
	set isOpen(bool) {
		this.active = bool ? 'x' : '';
		this._isOpen = bool;
	}

	@track active;
	@track _isOpen = false;
	customLabel = {labelAriaWrapper};
}