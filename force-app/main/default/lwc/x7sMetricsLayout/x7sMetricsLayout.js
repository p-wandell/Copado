/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class X7sMetricsLayout extends NavigationMixin(LightningElement) {
	
	@api title;
	@api titleAlignment = 'center';
	@api isBold = false;
	@api metricValue;
	@api metricValueType;
	@api metricLabel;
	@api iconName;
	@api iconHoverText;
	@api iconColor;
	@api iconVariant = 'Default';
	@api showLeftButton = false;
	@api labelForLeftButton;
	@api urlForLeftButton;
	@api showRightButton = false;
	@api labelForRightButton;
	@api urlForRightButton;
	@api customClass = '';
	
	renderedCallback() {
		if (this.isBold)
			this.template.querySelector('[data-id="metId"]').classList.add('fontbold');
		else
			this.template.querySelector('[data-id="metId"]').classList.remove('fontbold');
	}
	
	get isValueTypeCurrOrPer() {
		return (this.metricValueType === 'currency' || this.metricValueType === 'percent');
	}
	
	get showButton() {
		return (this.showLeftButton || this.showRightButton);
	}
	
	get styleIcon() {
		const iColor = ['background-color:' + this.iconColor];
		return iColor.join(';');
	}
	
	get richTitle() {
		return `<h2>${this.title}</h2>`;
	}
	
	navigateToWebPage() {
		this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.template.querySelector('lightning-button').value,
				}
			},
		);
	}
}