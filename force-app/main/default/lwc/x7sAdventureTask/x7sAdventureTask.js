/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire, track} from 'lwc';
import currentUserId from '@salesforce/user/Id';
import taskCompleted from '@salesforce/apex/x7sAdventureModuleTasks.taskCompleted';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {fireEvent} from 'c/x7sShrUtils';

export default class X7sAdventureTask extends NavigationMixin(LightningElement) {

    @api adventureTask;
    @api adventureSetup;
    @api currentUserId;
    @api restrictUser;
    @api taskCheckboxSetup;
    @api selection;
    @api listId = 'ID_1';
    @api myFilter;
    @api isLex;

    @api flaged;
    @api labelCss;
    @api spanCss;

    @track cardUrl;
    @track currentUrl;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        this.currentUserId = currentUserId;
        this.restrictUser = this.adventureTask !== this.currentUserId ? true : false;
        this.currentUrl = window.location.origin;
        this.flaged = this.adventureTask.Completed__c;
        if (this.flaged) {
            this.labelCss = 'slds-checkbox-button slds-checkbox-button_is-checked';
            this.spanCss = 'slds-icon_container slds-icon-utility-check slds-current-color';
        } else {
            this.labelCss = 'slds-checkbox-button';
            this.spanCss = 'slds-icon_container slds-current-color';
        }
    }

    get showTitleAsLink() {
        return this.adventureTask && this.adventureTask.Content_URL__c && this.adventureTask.Content_URL__c.trim().length>0;
    }

    isTaskCompleted(event) {

        let selectedTaskId = event.target.name;
        let buttonStatus = event.target.checked;

        if (selectedTaskId !== null) {

            let params = ({
                "selectedTaskId": selectedTaskId,
                "checkboxFlag": buttonStatus
            });

            taskCompleted(params)
                .then(result => {

                    if (result === true) {
                        this.showToast(this.adventureTask.Title__c, this.adventureSetup.Task_Completion_Checked_Text__c, 'success');
                    } else {
                        this.showToast(this.adventureTask.Title__c, this.adventureSetup.Task_Completion_Unchecked_Text__c, 'info');
                    }

                    fireEvent(this.pageRef, 'updatedTasks', {id: this.listId});

                    if (buttonStatus) {
                        this.flaged = buttonStatus;
                        this.labelCss = 'slds-checkbox-button slds-checkbox-button_is-checked';
                        this.spanCss = 'slds-icon_container slds-icon-utility-check slds-current-color';
                    } else {
                        this.flaged = buttonStatus;
                        this.labelCss = 'slds-checkbox-button';
                        this.spanCss = 'slds-icon_container slds-current-color';
                    }

                })
                .catch(error => {
                    this.error = error;
                });

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

    get checkboxStatus() {
        return this.restrictUser ? this.adventureTask.Restrict_to_User__c ? true : false : false;
    }

    get isAttachment() {

        let isDoc = false;

        if (this.adventureTask.hasOwnProperty('ContentDocumentLinks')) {
            isDoc = this.adventureTask.ContentDocumentLinks[0].hasOwnProperty('ContentDocumentId');
        }
        return isDoc;
    }

    get attachmentId() {

        if (this.adventureTask.hasOwnProperty('ContentDocumentLinks')) {
            if (this.adventureTask.ContentDocumentLinks[0].hasOwnProperty('ContentDocumentId')) {
                return this.adventureTask.ContentDocumentLinks[0].ContentDocumentId;
            }
        }
    }

    get modIconSize() {
        if(this.adventureTask.Icon_Name__c.includes('action:')) {
            return 'xx-small';
        }
        return "small";
    }

    get iconWrapperClass() {
        if(this.adventureTask.Icon_Name__c.includes('utility:')) {
            return 'slds-current-color task-icon-color';
        }
    }

    openSingleFile(event) {

        let fileId = event.currentTarget.dataset.id;
        let fileDownloadUrl = this.currentUrl + '/sfc/servlet.shepherd/document/download/' + fileId + '?operationContext=S1';

        if (this.isLex) {

            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state: {
                    selectedRecordId: fileId
                }
            });

        } else {
            /*   Download file
             this[NavigationMixin.Navigate]({
                 type : 'standard__webPage',
                 attributes :{
                     url: fileDownloadUrl
                 }
             }); */
            this.versionId = fileId;
            const event = new CustomEvent('thumbclick', {detail: this.versionId});
            this.dispatchEvent(event);
            eval("$A.get('e.lightning:openFiles').fire({recordIds: ['" + fileId + "']});");
        }
    }

    linkClick(event) {

        let url = event.currentTarget.dataset.href;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }
}