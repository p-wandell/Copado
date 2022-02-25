/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, track, api, wire} from 'lwc';
import userId from '@salesforce/user/Id';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import USER_CONTACTID from '@salesforce/schema/User.ContactId';
import noContactLabel from '@salesforce/label/c.x7sExpLabelNoContactId';
import noTeamLabel from '@salesforce/label/c.x7sExpAccountTeamsNoTeam';
import getAccountTeam from '@salesforce/apex/x7sExpMyAccountTeamController.getAccountTeam';
import {NavigationMixin} from 'lightning/navigation';
import {showToast} from 'c/x7sShrUtils';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';

export default class X7sExpMyAccountTeam extends NavigationMixin(LightningElement) {
    @api title;
    @api titleAlignment;
    @api description;
    @api customClass;
    @track message;
    @track contactId;
    @track teamList = [];
    @track loaded = false;
    label = {labelAriaWrapper};

    @wire(getRecord,{recordId: userId, fields: [USER_CONTACTID]})
    wiredUser({error, data}) {
        if (data) {
            this.contactId = getFieldValue(data, USER_CONTACTID);
            this.message = !this.contactId;
            if (this.contactId) {
                this.getAccountTeam();
            } else {
                this.message = noContactLabel;
                this.loaded = true;
            }
        } else if (error) {
            this.error = error;
        }
    }

    get componentClass() {
        let defaultClass = 'x7s-myaccountteam';
        return this.customClass != null ? defaultClass + ' ' + this.customClass : defaultClass;
    }

    renderedCallback() {
        // When component rendered
    }

    connectedCallback() {
        // When attributes available
    }

    getAccountTeam = () => {
        let params = {
            contactId: this.contactId
        };
        getAccountTeam(params).then(data => {
            if (data.success) {
                if (data.expResults.length === 0) {
                    this.teamList = data.results;
                    if (Array.isArray(this.teamList) && (this.teamList.length === 0)) {
                        this.message = noTeamLabel;
                    }
                } else {
                    this.message = data.messages[0];
                }
            } else {
                showToast('Account Team Error', data.messages[0], 'error', 'sticky');
            }
        }).catch(error => {
            showToast('Account Team Error', error, 'error', 'sticky');
        }).finally(() => {
            this.loaded = true;
        });
    };

    goToProfile = (event) => {
        let id = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view'
            }
        });
    };
}