/*
 * Copyright (c) 2021. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import labelAriaWrapper from '@salesforce/label/c.X7sQuestionnaireAriaLabelWrapper';

export default class x7sQuestionnaireNav extends LightningElement {
    @api scriptText;
    @api guidanceText;
    @api selectedValue = '';
    @api showGuidanceText;
    @api answer1;
    @api answer2;
    @api answer3;
    @api answer4;
    @api answer3Populated;
    @api answer4Populated;
    @api slds_icon = 'utility:question_mark';
    @api label;
    @api availableActions = [];

    @track value;
    label = {labelAriaWrapper};

    handleChange(event) {
        // notify the flow of the new todo list
        let response = event.target.label;
        console.log(response);
        this.value = response;

        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedValue', this.value);
        this.dispatchEvent(attributeChangeEvent);

        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}