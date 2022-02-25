/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, wire} from 'lwc';
import currentUserId from '@salesforce/user/Id';
import getAdventure from '@salesforce/apex/x7sAdventureBaseController.getAdventure';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import labelAriaWrapper from '@salesforce/label/c.x7sAdventureAriaLabelWrapper';

export default class Xx7sAdventureSteps extends LightningElement {

    @api recordId;
    @api metadataRecordName = 'Default';
    @api titleTextSize = 'large';
    @api adventureTitleTextColor;
    @api imagePosition = '';
    @api trailBackgroundColor;
    @api adventureStepTextColor;
    @api adventureStepBackgroundColor;
    @api buttonHoverColor = 'Black';
    @api truncate = false;
    @api showLinks = "true";
    @api showTrailOnMobile = false;
    @api moduleHeight = 100;
    @api customClass = '';
    @api customId = '';
    @api stepBannerAlign = 'left';
    @api displayStepTitle = "true";
    @api displayStepSubTitle = "true";;
    @api variant = "None";
    @api showOnlyMyTask = false;
    @api listId = 'ID_1';

    @api tileVariant = 'None';
    @api showAvatar = false;
    @api showImages;
    @api moduleProgressType = 'Progress-Bar';
    label = {labelAriaWrapper};

    get moduleProgress() {
        let flag = false;
        if (this.moduleProgressType === 'Progress-Bar') {
            flag = true;
        }
        return flag;
    }

    // --Attributes->
    @api adventureContentObject = [];
    @api adventure = []; //Map
    @api adventureTitleImage;
    @api adventureHeaderImage;
    @api adventureBannerImage;

    // --adventure configuration--
    @api adventureSetup = {}; // Object
    @api taskCheckboxSetup;
    @api currentUserId;
    @api currentModuleHeight;
    @api numberOfTasksRemaining;
    @api numberOfModuleTasks;
    @api adventureProgress;
    @api myFilter = false;
    @api isLex;
    @api showModuleTooltip = "true";

    @api adventureStepHeaderImage;
    @api selectedStep = {};
    @api defaultStep = 0;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {

        let userId = currentUserId;
        let url = window.location.href;
        let results = url.split("/");
        this.currentUserId = userId;

        if (results.indexOf('lightning') === -1) {
            this.isLex = false;
        } else {
            this.isLex = true;
        }
        this.getAdventureData();

        registerListener("selectedStepNumber", this.handleSelectedStep, this);
        // registerListener("taskProgress",this.getModuleProgress, this);
        registerListener("updatedTasks", this.updatedTasks, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    get displayVariant() {
        return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
    }

    get moduleDisplayVariant() {
        return this.tileVariant === 'Featured' ? 'featured' : 'default';
    }

    getParameters() {
        let parameters = {
            recordId: this.recordId,
            objectName: "X7S_Adventure__c",
            byOwnerId: this.myFilter ? true : false,
            setupName: this.metadataRecordName
        }
        return parameters;
    }

    getAdventureData() {
        let adventureId = this.recordId;

        if (adventureId) {
            getAdventure(this.getParameters())
                .then(results => {
                    if (results.success === false) {
                        if (results.messages) {
                            results.messages.foreach((message) => {
                                console.error(message);
                                this.showToast('Error', message, 'Error')
                            })
                        }
                        return;
                    }

                    this.adventureContentObject = results.adventureResults[0];
                    /* Set Adventure */
                    this.adventure = this.adventureContentObject.adventure;
                    /* Set metadata */
                    this.adventureSetup = results.globalSetting;
                    /* adventure setup CMT   */

                    let enableBox = this.adventureSetup.Enable_Checkbox_Display__c;
                    this.selectedStep = this.adventureContentObject.adventureStepWrapper[this.defaultStep];

                    if (enableBox !== true) {
                        if (this.adventure.Show_Checkboxes__c) {
                            this.taskCheckboxSetup = true;
                        } else {
                            this.taskCheckboxSetup = false;
                        }
                    } else {
                        this.taskCheckboxSetup = true;
                    }

                    if (this.myFilter) {
                        let completedTasks = (results.adventureProgress.totalTasksAssigned - results.adventureProgress.totalCompletedTasks);
                        this.numberOfModuleTasks = results.adventureProgress.totalTasksAssigned;
                        this.numberOfTasksRemaining = completedTasks;
                        this.adventureProgress = Math.round(results.adventureProgress.adventureProgress);
                    } else {
                        let completedTasks = (this.adventureContentObject.adventure.Number_of_Tasks__c - this.adventureContentObject.adventure.Number_of_Completed_Tasks__c);
                        this.numberOfModuleTasks = this.adventureContentObject.adventure.Number_of_Tasks__c;
                        this.numberOfTasksRemaining = completedTasks;
                        this.adventureProgress = Math.round(this.adventureContentObject.adventure.Task_Progress__c);
                    }

                    //Title image is image behind the title
                    //Header Image is image next to Adventure Step Title
                    //Banner is image behind the trail

                    let docLinks = this.adventureContentObject.adventure;

                    if (docLinks.hasOwnProperty('ContentDocumentLinks')) {

                        for (let i = 0; i < this.adventureContentObject.adventure.ContentDocumentLinks.length; i++) {

                            let conDocLink = this.adventureContentObject.adventure.ContentDocumentLinks[i];
                            if (conDocLink) {

                                let title = conDocLink.ContentDocument.Title.toLowerCase();
                                console.log('old For :' + title);
                                if (title.indexOf('title') !== -1) {
                                    this.adventureTitleImage = conDocLink.ContentDocument.LatestPublishedVersionId;
                                }
                                if (title.indexOf('header') !== -1) {
                                    this.adventureHeaderImage = conDocLink.ContentDocument.LatestPublishedVersionId;
                                }
                                if (title.indexOf('banner') !== -1) {
                                    this.adventureBannerImage = conDocLink.ContentDocument.LatestPublishedVersionId;
                                }
                            }
                        }
                    }
                    
                    fireEvent(this.pageRef, 'adventureBanner', {
                        id: this.listId, adventure: this.adventure,
                        isLex: this.isLex,
                        taskCheckboxSetup: this.taskCheckboxSetup,
                        adventureProgress: this.adventureProgress,
                        numberOfTasksRemaining: this.numberOfTasksRemaining,
                        numberOfTasks: this.numberOfModuleTasks,
                        topics: this.adventureContentObject.topics
                    });

                    fireEvent(this.pageRef, 'adventureProgress', {
                        id: this.listId, isLex: this.isLex,
                        trailBackgroundColor: this.trailBackgroundColor,
                        adventureBannerImage: this.adventureBannerImage,
                        adventureContentObject: this.adventureContentObject
                    });

                })
                .catch(error => {
                    this.error = error;
                    console.error(error);
                    this.showToast('Error', this.error.message, 'Error')
                })


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

    get sectionClass() {
        return `x7s-adventure ${this.customClass}`;
    }

    updatedTasks(event) {
        if (this.listId === event.id) {
            this.getAdventureData();
        }
    }

    filterByTask(event) {
        const chileEventObt = event.detail;
        this.myFilter = chileEventObt;
        this.getAdventureData();
    }

    handleSelectedStep(event) {
        if (this.listId === event.id) {
            this.defaultStep = event.selected;
            //this.getAdventureData();
            this.selectedStep = this.adventureContentObject.adventureStepWrapper[this.defaultStep];
        }
    }
}