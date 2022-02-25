/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import ss_idea_label_points from "@salesforce/label/c.x7sIdeasVotePoints";

export default class X7sIdeasPoints extends LightningElement {
	
	@api points;
	@api variant; //Can be large for bold style
	formatPoints = true;
	formattedPoints;
	labelPoints = ss_idea_label_points;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.get_formatPoints();
		registerListener("ideaspoints", this.get_formatPoints, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get labelclass() {
		return this.variant === 'large' ? 'slds-text-color_weak slds-text-heading--small slds-p-bottom_none idea-points__boldStyle' : 'idea-points__label';
	}
	
	get pointsClass() {
		return this.variant === 'large' ? 'slds-text-heading--large idea-points__boldStyle' : 'idea-poins-size';
	}
	
	get pointsDisplay() {
		return this.formatPoints ? this.formattedPoints ? this.formattedPoints : '0' : this.points;
	}
	
	get_formatPoints() {
		if (this.formatPoints && this.points !== null) {
			const points = this.points;
			let formattedPoints = points;
			if (points >= 1000000000) {
				formattedPoints = (points / 1000000000).toFixed(1).replace(/\.0$/, '') + 'b';
			} else if (points >= 1000000) {
				formattedPoints = (points / 1000000).toFixed(1).replace(/\.0$/, '') + 'm';
			} else if (points >= 1000) {
				formattedPoints = (points / 1000).toFixed(1).replace(/\.0$/, '') + 'k';
			} else if (points === 0) {
				formattedPoints = 0;
			}
			this.formattedPoints = formattedPoints;
		}
	}
}