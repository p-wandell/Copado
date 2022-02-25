/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

import toggleButtonLabel from '@salesforce/label/c.x7sAdventureToggleButtonLabel';

export default class X7sAdventureStepsBanner extends LightningElement {
    
    @api headerMinHeight = 109;
    @api currentHeaderHeight = 50;
    @api currentHeaderOffset = 90;
    @api adventureStepBackgroundColor;
    @api adventureStepTextColor;
    @api adventureHeaderImage;
    @api stepTitle;
    @api stepSubtitle
    @api adventureStepHeaderImage;
    @api stepBannerAlign;
    @api taskCheckboxSetup = false;
    @api myFilter;
    @api displayStepTitle;
    @api displayStepSubTitle;
    @api showOnlyMyTask = false;

    labels = {
        toggleButtonLabel
    }

    get showTitle() {
        if (typeof(this.displayStepTitle) === "string") {
            return this.displayStepTitle.toLowerCase() === 'true';
        }

        return this.displayStepTitle;
    }

    get showSubTitle() {
        if (typeof(this.displayStepSubTitle) === "string") {
            return this.displayStepSubTitle.toLowerCase() === "true";
        }

        return this.displayStepSubTitle;
    }

    get moduleClass() {
        return 'slds-text-heading_medium slds-p-top_x-small slds-p-bottom_x-small slds-p-horizontal_small slds-text-align_' + this.stepBannerAlign;
    }

    get moduleDetailClass() {
        return 'slds-p-top_none slds-p-bottom_small slds-p-horizontal_small slds-text-align_' + this.stepBannerAlign;
    }

    get showOnlyMyTaskToggle() {
        return this.showOnlyMyTask && this.taskCheckboxSetup;
    }

    filterByTask(event) {
        this.myFilter = event.target.checked;
        const toggleClicked = new CustomEvent('toggleflag', {detail: this.myFilter, bubbles: true});
        this.dispatchEvent(toggleClicked);
    }
}