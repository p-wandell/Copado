/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import {api, LightningElement, track, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent} from 'c/x7sShrUtils';

import x7s_News_Filters_Topics from '@salesforce/label/c.x7sNewsFiltersTopics';
import x7s_News_Filters_Author from '@salesforce/label/c.x7sNewsFiltersAuthor';
import x7s_News_Label_Select_Author from '@salesforce/label/c.x7sNewsLabelSelectAuthor';
import x7s_Topic_Placeholder from '@salesforce/label/c.x7sTopicPlaceholder';
import labelStartDate from '@salesforce/label/c.x7sNewsFilterLabelStartDate';
import labelEndDate from '@salesforce/label/c.x7sNewsFilterLabelEndDate';
import labelButtonClear from '@salesforce/label/c.x7sNewsFilterButtonClear';
import x7sNewsCreateLabelButtonAddTopics from '@salesforce/label/c.x7sNewsCreateLabelButtonAddTopics';
import x7sNewsCreateLabelButtonAddAuthors from '@salesforce/label/c.x7sNewsCreateLabelButtonAddAuthors';
import x7sNewsAriaLabelForNewsFilterLandmark from '@salesforce/label/c.x7sNewsAriaLabelForNewsFilterLandmark';
import x7sNewsAriaLabelForSelectedTopics from '@salesforce/label/c.x7sNewsAriaLabelForSelectedTopics';
import x7sNewsAriaLabelForSelectedAuthors from '@salesforce/label/c.x7sNewsAriaLabelForSelectedAuthors';

import getTopics from "@salesforce/apex/x7sNewsController.getTopics";
import getAuthors from "@salesforce/apex/x7sNewsController.getAuthors";

export default class X7sNewsFilters extends LightningElement {

    @api customClass;
    @api listId;
    @api showTopic;
    @api showAuthor;
    @api showDate;

    @track newsTopic=[];
    @track newsAuthor=[];
    @track selectedItemIds=[];
    selectedAuthorItemIds = [];
    addAuthor = x7sNewsCreateLabelButtonAddAuthors;
    addTopics = x7sNewsCreateLabelButtonAddTopics;
    ariaLabelForNewsCreateLandmark = x7sNewsAriaLabelForNewsFilterLandmark;
    selectedTopicsLabel = x7sNewsAriaLabelForSelectedTopics;
    selectedAuthorsLabel = x7sNewsAriaLabelForSelectedAuthors;
    error;
    @track startDate;
    @track endDate;

    @wire(CurrentPageReference) pageRef;

    labels ={
         x7s_News_Filters_Topics,
         x7s_News_Filters_Author,
         x7s_News_Label_Select_Author,
         x7s_Topic_Placeholder: x7s_Topic_Placeholder,
         labelStartDate,
         labelEndDate,
         labelButtonClear
    }
    connectedCallback(){
        this.getTopicValues();
        this.getAuthorValues();
    }
    get componentClass() {
		return `x7s-news-filters ${this.customClass}`;
    }
    getTopicValues(){
        getTopics()
			.then(result => {
                let data = result;
				this.newsTopic=Object.keys(data).map((key) => {
	                return ({name: data[key], id: key});
                });
			})
			.catch(error => {
				this.error = error;
			});
    }
    sendFilterNewsEvent(){
        let _selectedItemIds = this.selectedItemIds;
	    let _selection = '';

	    for(let i=0;i<_selectedItemIds.length;i++) {
	        if(i === (_selectedItemIds.length -1))
	            _selection += _selectedItemIds[i];
	        else
	            _selection += _selectedItemIds[i] + ';';
        }
        fireEvent(this.pageRef, 'newstopicevent', {id: this.listId, value: _selection});
    }
    sendFilterAuthorEvent(){
        let _selectedItemIds = this.selectedAuthorItemIds;
	    let _selection = '';

	    for(let i=0;i<_selectedItemIds.length;i++) {
	        if(i === (_selectedItemIds.length -1))
	            _selection += _selectedItemIds[i];
	        else
	            _selection += _selectedItemIds[i] + ';';
        }
        fireEvent(this.pageRef, 'newsauthorevent', {id: this.listId, value: _selection});
    }
    handleTopicChangeEvent(event) {
        this.selectedItemIds = event.detail;
        this.sendFilterNewsEvent();
    }
    handleAuthorChangeEvent(event) {
        this.selectedAuthorItemIds = event.detail;
        this.sendFilterAuthorEvent();
    }
    getAuthorValues(){
        getAuthors()
			.then(result => {
				let data = result;
				this.newsAuthor = Object.keys(data).map((key) => {
					return ({name: data[key], id: key});
                });
                console.log('---newsAuthor----'+this.newsAuthor);
			})
			.catch(error => {
				this.error = error;
			});
    }
    startDateChange(event){
        this.startDate = event.detail.value;
        fireEvent(this.pageRef, 'newsstartdate',{id: this.listId, value: this.startDate});
        let buttonId = this.template.querySelector('lightning-button-icon');
        if(this.startDate){
            buttonId.disabled = false; 
        }
    }
    endDateChange(event){
        this.endDate = event.detail.value;
        fireEvent(this.pageRef, 'newsenddate',{id: this.listId, value: this.endDate});
        let buttonId = this.template.querySelector('lightning-button-icon');
        if(this.endDate){
            buttonId.disabled = false; 
        }
    }
    clearDates(){
        this.startDate = '';
        this.endDate='';
        fireEvent(this.pageRef, 'newsstartdate',{id: this.listId, value: this.startDate});
        fireEvent(this.pageRef, 'newsenddate',{id: this.listId, value: this.endDate});
        let buttonId = this.template.querySelector('lightning-button-icon');
        buttonId.disabled = true; 
    }
}