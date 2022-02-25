/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import { LightningElement,api,track } from 'lwc';

import initVolunteerNeeds       from '@salesforce/apex/x7sEventsVolunteersController.initVolunteerNeeds';
import createVolunteerNeeds     from '@salesforce/apex/x7sEventsVolunteersController.createVolunteerNeeds';
import getSitePrefix            from '@salesforce/apex/x7sEventsVolunteersController.getSitePrefix';

import { NavigationMixin } from "lightning/navigation";

import ErrorMessageDescription from '@salesforce/label/c.x7sEventsDescriptionErrorMessage';
import labelVolunteerDesc from '@salesforce/label/c.x7sEventsVolNeedFormDesc';
import labelVolunteerDescHelp from '@salesforce/label/c.x7sEventsVolNeedFormDescHelp';
import labelTask from '@salesforce/label/c.x7sEventsVolNeedFormTask';
import labelName from '@salesforce/label/c.x7sEventsVolNeedFormLabelName';
import labelCriteria from '@salesforce/label/c.x7sEventsVolNeedFormLabelCriteria';
import labelTaskName from '@salesforce/label/c.x7sEventsVolNeedFormLabelTaskName';
import labelVolunteersNeeded from '@salesforce/label/c.x7sEventsVolNeedFormVolunteersNeeded';
import labelAddTask from '@salesforce/label/c.x7sEventsVolNeedFormAddTask';
import labelSaveButton from '@salesforce/label/c.x7sEventsVolNeedFormButtonSaveButton';
import labelCancelButton from '@salesforce/label/c.x7sEventsVolNeedFormLabelCancelButton';
import labelRemove from '@salesforce/label/c.x7sEventsVolNeedFormRemove';
import labelNoVolunteerLimitMsg from '@salesforce/label/c.x7sEventsNoVolunteerLimitMsg';
import labelVolunteerNeedErrMsg from '@salesforce/label/c.x7sEventsVolunteerNeedErrMsg';

export default class X7sEventsVolunteerNeedForm extends NavigationMixin(LightningElement) {

    @api recordId;
    @api sitePath;
    @api sitePrefix;
    @track taskRecord ={};
    event = {'sobjectType':'Event__c'};
    volunteerDescription;
    @track lineItems = [];
    submissionSuccess = false;
    @track saveResults = [];
    disableButton = false;
    sitePrefix;
    detailPageUrl = "/event/"
    validity = true;
    isInit = false;
    @track needsToRemove = [];
    strError;
    recordPageRef;

    labels = {
        labelVolunteerDesc,
        labelVolunteerDescHelp,
        labelTask,
        labelName,
        labelCriteria,
        labelTaskName,
        labelVolunteersNeeded,
        labelAddTask,
        labelSaveButton,
        labelCancelButton,
        labelRemove,
        labelNoVolunteerLimitMsg,
        ErrorMessageDescription,
        labelVolunteerNeedErrMsg
    };

    connectedCallback(){
        this.get_SitePrefix();
        this.initRecord();
    }
    get detailPageURL(){
        return this.sitePath + this.detailPageUrl + this.recordId;
    }

    get_SitePrefix(){
        getSitePrefix()
        .then(result => {
            let sitePath = result;
            if(sitePath){
                this.sitePath = sitePath;
                let position = sitePath.lastIndexOf('/s');
                this.sitePrefix = sitePath.substring(0, position);
            }
        })
        .catch(error => {
            console.log("Error occurred getting site prefix:"+error);
        })
    }

    removeLineItem(event){
        let targetID = event.target.dataset.id;
        let index = parseInt(targetID);

        let lineItems = this.lineItems;

        let results = lineItems.splice(index,1);
        this.needsToRemove.push(results[0]);
        this.lineItems = lineItems;
    }

    initRecord(){
        this.needsToRemove =[];
        initVolunteerNeeds({
            eventIdString: this.recordId
        })
        .then(result => {
            let tempData = result;
            
            if (tempData && tempData.Volunteer_Description__c){
               this.volunteerDescription = tempData.Volunteer_Description__c;
            }
            
            if (tempData && tempData.Volunteer_Needs__r){
                this.lineItems = tempData.Volunteer_Needs__r;
            }
            else{
                this.lineItems = [];
            }   
            // replace 999999 volunteers needed with 0 (no limit) for display only
            // this will be restored to 999999 on save if user leaves value at 0
            // 999999 = no-limit flag

            for (let x=0;x<this.lineItems.length;x++) {
                if (this.lineItems[x].Volunteers_Needed__c === 999999) {
                    this.lineItems[x].Volunteers_Needed__c = 0;
                }

                this.lineItems[x].taskNumber = x + 1;
                this.lineItems[x].lineItemId = x;
                //Added to use in HTML
            }
    
            this.event = tempData;
            this.addLineItem();
            this.isInit = true;
        })
        .catch(error => {
            console.log("Error occurred initializing volunteerneeds:"+error);
        })
    }
    handleInputChange(event){
        let eventId = this.recordId;
        let taskRecord = {};
        taskRecord['Volunteers_Needed__c'] = 1;
        taskRecord['Event__c'] = eventId;
        taskRecord['sobjectType'] = "X7S_Events_Volunteer_Need__c";
        taskRecord['taskNumber'] = parseInt(event.target.dataset.tasknumber);
        taskRecord['lineItemId'] = parseInt(event.target.dataset.lineitem);
        let updateLineItem = {};
        const field = event.target.name;
        if(field === 'Name'){
            taskRecord.Name = event.target.value;
        }
        if(field === 'Criteria__c'){
            taskRecord.Criteria__c = event.target.value;
        }
        if(field === 'Volunteers_Needed__c'){
            taskRecord.Volunteers_Needed__c = event.target.value;
        }

        let lineItems = this.lineItems;
        if(lineItems && lineItems.length){
            for(let x=0 ; x<lineItems.length ; x++){
                if(lineItems[x].taskNumber === parseInt(taskRecord.taskNumber)){
                    lineItems[x].Event__c = this.recordId;
                    lineItems[x].sobjectType = "X7S_Events_Volunteer_Need__c";
                    lineItems[x].Criteria__c = taskRecord.Criteria__c || lineItems[x].Criteria__c;
                    lineItems[x].Name = taskRecord.Name || lineItems[x].Name;
                    lineItems[x].Volunteers_Needed__c =  taskRecord.Volunteers_Needed__c || lineItems[x].Volunteers_Needed__c;
                    lineItems[x].taskNumber =  lineItems[x].taskNumber;
                    lineItems[x].lineItemId  = lineItems[x].lineItemId;
                    updateLineItem.push(lineItems[x]);
                }
            }
            this.lineItems.push(updateLineItem);

        }  
    }
    
    addLineItem(){

        let eventId = this.recordId;
        let numOfItems = 0;
        let lineItems = this.lineItems;
        
        if(lineItems && lineItems.length){
            numOfItems = this.lineItems.length + 1;
        }
        else{
            numOfItems = 1;
        }
            lineItems.push({
            Event__c: eventId,
            sobjectType: "X7S_Events_Volunteer_Need__c",
            Name:"",
            Volunteers_Needed__c: 1,
            taskNumber: numOfItems,
            lineItemId : this.lineItems.length
        });
        this.lineItems = lineItems;
    }

    handleVolDecChange(evt){
        this.volunteerDescription = evt.target.value;
		this.validateVolDescription(this.volunteerDescription);
    }

    validateVolDescription(volunteerDescription){
        this.validity = !!volunteerDescription && !!this.getHtmlPlainText(volunteerDescription).trim();
    }

    getHtmlPlainText(htmlString){
        //Remove all HTML Tags, This is required to check Initial space if entered
        return htmlString.replace(/<[^>]+>/g, '');
    }

    saveAction(){
        this.validateVolDescription(this.volunteerDescription);
        if(this.validity){
            this.strError = "";
            let event = this.event;
            event.Volunteer_Description__c = this.volunteerDescription;
            let lineItems = this.lineItems;
            console.log('----In save Method----'+JSON.stringify(this.lineItems));
            let lineItemsToRemove = this.needsToRemove;
            let detailPageUrl = this.detailPageUrl;
            let recordId = this.recordId;


            // replace 0 volunteers needed with 999999 (no-limit flag)
            for (let x=0;x<lineItems.length;x++) {
                if (lineItems[x].Volunteers_Needed__c === 0) {
                    lineItems[x].Volunteers_Needed__c = 999999
                }
            }

            // remove Line items with empty name or volunteers needed
            lineItems = lineItems.filter(obj => {
                return obj.Name !== '' && obj.Volunteers_Needed__c !== '';
            });
            lineItemsToRemove = lineItemsToRemove.filter(obj => {
                return obj.Id != null;
            });

            // // And now translate all
            // for (let x=0;x<lineItems.length;x++) {
            //     lineItems[x] = self.setNamespace(component, lineItems[x]);
            // }

            // Set both event and needs because event.somelist__r does not get passed back to Apex!

            createVolunteerNeeds({
                event           : event,
                volunteerNeeds  : lineItems,
                needsToRemove   : lineItemsToRemove
            })
            .then(result => {
                let saveResults = result;
                if (saveResults.length>0){
                    this.saveResults = saveResults;
                } else {
                    this.submissionSuccess = true;
                    this.needsToRemove = []; // empty needs to remove array
                    this.goToURL(detailPageUrl + recordId);
                }
            })
            .catch(error => {
                console.log("Error occurred creating volunteer needs:"+error);
            })
        }
        else
            this.strError = labelVolunteerNeedErrMsg;
    }

    goToURL(url){
		this[NavigationMixin.Navigate]({
			type: "standard__webPage",
			attributes: {
				url: url
			}
        });
        console.log("In goToURL");
    }
}