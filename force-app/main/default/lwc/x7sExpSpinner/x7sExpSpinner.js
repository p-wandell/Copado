/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

import X7S_Loading_Label from '@salesforce/label/c.x7sExpLabelLoading';

export default class X7sExpSpinner extends LightningElement {
	@api alternativeText = X7S_Loading_Label;
	@api size = 'medium'; // Accepted values - small,medium,large
	@api title = X7S_Loading_Label;
	@api variant = 'brand'; // Accepted values - base,brand,inverse
}