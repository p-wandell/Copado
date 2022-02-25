/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import labelProgressAltText from '@salesforce/label/c.x7sAdventureAriaStepProgress';

export default class X7sAdventureProgress extends LightningElement {
    @api isLex;
    @api adventureProgressImage;
    @api adventureContentObject = [];
    @api listId = 'ID_1';
    @api customClass = '';

    @api currentIndex = 0;
    @api currentStep = 0;
    @api currentName;
    @api trailBackgroundColor;

    @wire(CurrentPageReference) pageRef;
    label = {labelProgressAltText};

    connectedCallback() {
        let contentObject = this.adventureContentObject;
        registerListener("adventureProgress", this.handleProgress, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleIconNext(event) {
        this.currentStep = event.target.value;
        fireEvent(this.pageRef, 'selectedStepNumber', {id: this.listId, selected: this.currentStep});
    }

    handleDivNext(event) {
        this.currentStep = parseInt(event.target.getAttribute('data-id'));
        fireEvent(this.pageRef, 'selectedStepNumber', {id: this.listId, selected: this.currentStep});
    }

    get stepSectionClass() {
        return this.isLex ? 'adventure-bannerLEX' : 'adventure-banner';
    }

    get showSteps() {
        return this.adventureContentObject && this.adventureContentObject.adventureStepWrapper && this.adventureContentObject.adventureStepWrapper.length > 1;
    }

    get stepItems() {
        return 'adventure-step slds-p-vertical_small slds-size_1-of-' + this.adventureContentObject.adventureStepWrapper.length;
    }

    getStepParameter() {
        let stepParameter = parseInt(this.getUrlParameter('step'), 10);

        // Check if `stepParameter` is a number and proper range, then decrement the value.
        if (!isNaN(stepParameter) && stepParameter > 0) {
            return stepParameter - 1;
        }

        // Otherwise, zero is the answer.
        return 0;
    }

    getUrlParameter(sParam) {

        let sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
        return null;
    }

    get sectionClass() {
        return `x7s-adventure ${this.customClass}`;
    }

    handleProgress(event) {
        if (this.listId === event.id) {
            this.trailBackgroundColor = event.trailBackgroundColor;
            this.adventureProgressImage = event.adventureBannerImage;
            this.adventureContentObject = event.adventureContentObject;
            this.isLex = event.isLex;
        }
    }
}