/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, track} from 'lwc';
import getConfiguration from '@salesforce/apex/x7sAdventureCloneProjectAssignment.getConfiguration';
import cloneAdventure from '@salesforce/apex/x7sAdventureCloneProjectAssignment.cloneAdventure';
import checkCanClone from '@salesforce/apex/x7sAdventureCloneProjectAssignment.checkCanClone';

import labelButtonYes from "@salesforce/label/c.x7sAdventureCloneButtonYes";
import labelButtonNo from "@salesforce/label/c.x7sAdventureCloneButtonNo";
import LabelModal from "@salesforce/label/c.x7sAdventureCloneButtonLabel";
import cloneAdventureName from "@salesforce/label/c.x7sAdventureCloneName";
import cloneAdventureContinue from "@salesforce/label/c.x7sAdventureContinueCloneText";
import cloneAdventureEnableShowCheckboxes from "@salesforce/label/c.x7sAdventureCloneEnableShowCheckboxes";
import cloneAdventureExists from "@salesforce/label/c.x7sAdventureCloneExistsWarningText";
import descriptiveText from "@salesforce/label/c.x7sAdventureLabelCloneProceed";
import cloneToastTitle from "@salesforce/label/c.x7sAdventureCloneToastTitle";

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {stringifyThrownLdsError as stringifyError} from 'c/x7sShrUtils';

export default class X7sAdventureFullClone extends LightningElement {

    @track clonedID;
    @track adventureSetup = {
        globalSettings: {},
        clonedAdventureName: 'Cloned adventure',
        exists: false
    };
    @api isLoading = false;
    @api recordId;
    @api cloneButtonLabel;
    @track isModalOpen = false;

    hasCloneAccess = false;

    labels = {
        labelButtonYes,
        labelButtonNo,
        LabelModal,
        cloneAdventureName,
        descriptiveText,
        cloneAdventureContinue,
        cloneAdventureEnableShowCheckboxes,
        cloneAdventureExists
    }

    showCheckboxes = 'Enable Show Checkboxes';

    connectedCallback() {
        this.getAdventureMeta();
        this.canCloneAdventure();
    }

    get buttonLabel() {
        return this.cloneButtonLabel !== undefined && this.cloneButtonLabel !== '' ? this.cloneButtonLabel : LabelModal;
    }

    getAdventureMeta() {
        getConfiguration({selectedAdventureId: this.recordId})
            .then(results => {
                this.adventureSetup = results;
            })
            .catch(error => {
                console.error('Error getting configuration: ' + JSON.stringify(error));
            });
    }

    canCloneAdventure() {
        checkCanClone({selectedAdventureId: this.recordId})
            .then (canClone => {
                this.hasCloneAccess = canClone;
            })
            .catch(error => {
                console.error('Error checking clone access: ' + JSON.stringify(error));
            });
    }

    fullClone() {

        const inputName = this.template.querySelector(".cloneNameClass").value;
        const showCheckboxes = this.template.querySelector(".showCheckboxes").checked;

        this.isLoading = true;
        let adventureId = this.recordId;
        if (adventureId !== undefined) {

            let params = {
                selectedAdventureId: adventureId,
                clonedAdventureName: inputName,
                showCheckboxes: showCheckboxes,
                childCloneSetting: this.adventureSetup.cloneSettings.Child_Clone_Setting__c
            }

            cloneAdventure(params)
                .then(results => {
                    this.isLoading = false;
                    this.isModalOpen = false;
                    this.clonedID = results;
                    this.showToast(cloneToastTitle, this.adventureSetup.cloneSettings.Full_Clone_Success_Text__c, 'success');
                })
                .catch(error => {
                    this.isLoading = false;
                    this.showToast(cloneToastTitle, this.adventureSetup.cloneSettings.Full_Clone_Error_Text__c + ": " + stringifyError(error), 'error');
                    this.error = error;
                });
        } else {
            this.isLoading = false;
            this.showToast(cloneToastTitle, this.adventureSetup.cloneSettings.Full_Clone_Error_Text__c + ': Component Configuration Error - recordId not detected on page.', 'error');
        }

    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}