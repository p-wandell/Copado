/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-04-09.
*/
import {LightningElement, track, api, wire} from 'lwc';
import getAssets from '@salesforce/apex/x7S_CommunityAssetsController.getAssets';
import getObjectAPIName from '@salesforce/apex/x7S_CommunityAssetsController.getObjectAPIName';
import getFieldLabels from '@salesforce/apex/x7S_CommunityAssetsController.getFieldLabels';
import {NavigationMixin} from 'lightning/navigation';
import {getRecord} from 'lightning/uiRecordApi';
import COMMUNITY_ASSET_OBJECT from '@salesforce/schema/Community_Asset__c';
import NAME_FIELD from '@salesforce/schema/Community_Asset__c.Name';
import ASSET_OWNER_FIELD from '@salesforce/schema/Community_Asset__c.Asset_Owner__c';
import CATEGORY_FIELD from '@salesforce/schema/Community_Asset__c.Category__c';
import CLIENT_FIELD from '@salesforce/schema/Community_Asset__c.Client__c';
import LINK_FIELD from '@salesforce/schema/Community_Asset__c.Link__c';
import ORDER_FIELD from '@salesforce/schema/Community_Asset__c.Order__c';
import PROJECT_FIELD from '@salesforce/schema/Community_Asset__c.Project__c';
import RELATED_RECORD_FIELD from '@salesforce/schema/Community_Asset__c.Related_Record__c';
import x7SUtils from 'c/x7SUtils';
export default class x7SCommunityAssets extends NavigationMixin(LightningElement) {

    @api recordId;
    @api objectApiName;
    @api userData;
    @api assetFields;
    @api newPage;
    @api showHeaders;
    @api listTitle;
    @api newButtonLabel;
    @api customId;
    @api customClass;
    @track listLoaded = false;
    @track hasItems = false;
    @track refreshing = false;
    @track headersLoaded = false;
    @track displayTitle;
    @track displayNewButton;
    @track displayTitleArea;
    @track assetList;
    @track fieldLabels;
    @track error;
    @track fieldList = [];
    @track showForm = false;
    @track formFields;
    @track theForm;
    @wire(getObjectAPIName, {recordId: '$recordId'})
    wiredRecord({error, data}) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            x7SUtils.showToast('error', message);
        } else if (data) {
            this.objectApiName = data;
            this.prepareFormFields();
            this.assetFields = this.assetFields.split(',');
            this.displayTitle = x7SUtils.isDefined(this.listTitle);
            this.displayNewButton = x7SUtils.isDefined(this.newButtonLabel);
            this.displayTitleArea = this.displayTitle || this.displayNewButton;
            getFieldLabels({assetFields: this.getFieldList()}).then(data => {
                if(data.success) {
                    this.fieldLabels = data.labels;
                    this.headersLoaded = this.showHeaders && x7SUtils.isDefined(this.fieldLabels);
                    this.getAllAssets();
                }else{
                    x7SUtils.showToast('error', data.messages[0]);
                    console.log( data.messages[0]);
                }
            }).catch(error => {
                x7SUtils.showToast('error', error);
                console.log(error);
            });
        }
    }
    renderedCallback() {
        this.theForm = this.template.querySelector('lightning-record-edit-form');
    }
    getAllAssets(){
        getAssets({parentId: this.recordId}).then(data => {
            let hasLinkField = this.getFieldList(true).indexOf('Link') !== -1;
            this.assetList = [];
            for(var i = 0; i < data.results.length; i++){
                let assetFieldData = [];
                for(var x = 0; x < this.fieldList.length; x++){
                    let fieldObject = {};
                    fieldObject.value = this.fieldList[x].field !== 'Owner' ? data.results[i][this.fieldList[x].field] : data.results[i]['Asset_Owner__r']['Name'];
                    fieldObject.class = this.fieldList[x].class;
                    fieldObject.field = this.fieldLabels[x];
                    switch(this.fieldList[x].field) {
                        case 'Name':
                            fieldObject.link = !hasLinkField ? this.getLinkObject(data.results[i]['Link__c'], fieldObject.value) : null;
                            break;
                        case 'Link':
                            fieldObject.value = hasLinkField ? fieldObject.field : null;
                            fieldObject.link = hasLinkField ? this.getLinkObject(data.results[i]['Link__c'], fieldObject.value): null;
                            break;
                        case 'Owner':
                            fieldObject.link = this.getLinkObject(data.results[i]['Asset_Owner__r']['Id'], fieldObject.value, true);
                            break;
                    }
                    assetFieldData.push(fieldObject);
                }
                this.assetList.push(assetFieldData);
            }
            this.listLoaded = true;
            this.refreshing = false;
            this.hasItems = this.assetList.length > 0;
            if(!data.success){
                x7SUtils.showToast('error', data.messages[0]);
                console.log( data.messages[0]);
            }
        }).catch(error => {
            x7SUtils.showToast('error', error);
            console.log(error);
        });
    }
    getLinkObject(url, value, record){
        let possession = value[value.length -1] === 's' ? '\'' : '\'s';
        let tooltip = !record ? 'Open ' + value : 'Navigate to ' + value + possession + ' profile';
        return {
            record: record,
            url: url,
            target: this.newPage ? '_blank' : '',
            tooltip: tooltip
        };
    }
    getFieldList(setList){
        let fieldsHolder = [];
        if(setList) {
            this.fieldList = [];
        }
        for(let z = 0; z < this.assetFields.length; z++){
            let fieldInfo = this.assetFields[z].split(':');
            fieldsHolder.push(fieldInfo[0]);
            if(setList){
                this.fieldList.push({
                    field: fieldInfo[0],
                    label: this.fieldLabels[z],
                    class: fieldInfo[1] ? 'column column-grow-' + fieldInfo[1] : 'column'
                });
            }
        }
        return fieldsHolder;
    }
    prepareFormFields(){
        this.formFields = [];
        let objectField;
        let fields = [NAME_FIELD, LINK_FIELD, ORDER_FIELD, ASSET_OWNER_FIELD, CATEGORY_FIELD, CLIENT_FIELD, PROJECT_FIELD, RELATED_RECORD_FIELD];
        switch (this.objectApiName) {
            case 'pse__Proj__c':
                objectField = PROJECT_FIELD;
                break;
            case 'Account':
                objectField = CLIENT_FIELD;
                break;
            default:
                objectField = RELATED_RECORD_FIELD;
        }
        for(let i = 0; i < fields.length; i++){
           let currentField = {
               field: fields[i]
           };
           if(currentField.field === ASSET_OWNER_FIELD){
               currentField.value = x7SUtils.getCurrentUserId();
           }
            if(currentField.field === objectField){
                currentField.value = this.recordId;
                currentField.disabled = true;
            }
           this.formFields.push(currentField);
        }
    }
    navigateToOwnerRecord(event){
        event.preventDefault();
        const urlId = event.target.getAttribute('href');
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: urlId,
                actionName: 'view'
            }
        });
    }
    openForm(){
        this.showForm = true;
    }
    closeForm(){
        this.showForm = false;
    }
    submitForm(event){
        // event.preventDefault();
        this.theForm.submit();
    }
    formSuccess(event){
        this.closeForm();
        x7SUtils.showToast('success', 'Asset Successfully Created');
        this.refreshing = true;
        this.getAllAssets();
    }
}