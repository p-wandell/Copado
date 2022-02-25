/*
 * Copyright (c) 2021. 7Summits Inc.
 */

import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from "c/x7sShrUtils";
import labelAriaAltText  from '@salesforce/label/c.x7sAdventureLeaderboardAriaAltText';

export default class x7sLeaderboardCustomTypeControl extends LightningElement {
    
    @api url;
    @api altText;
    @api imageSize = 'Medium';
    @api imageShape = 'Square';

    @wire(CurrentPageReference) pageRef; 
    label = {labelAriaAltText}; 

    connectedCallback() {        
        registerListener("imagevariant",this.handleImageAttribute, this);
    }

    disconnectedCallback() {
		unregisterAllListeners(this);
    }

    handleImageAttribute(event) {
        this.imageSize = event.size;
        this.imageShape = event.shape;
    }
}