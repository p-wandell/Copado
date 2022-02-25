/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import { LightningElement,api,wire } from 'lwc';

import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {CurrentPageReference} from 'lightning/navigation';
import {events, custom} from 'c/x7sEventsBase';

import getEventPickList from '@salesforce/apex/x7sEventsListController.getEventPickList';
import getEventTypeList from '@salesforce/apex/x7sEventsListController.getEventTypeList';
import getTopics 		from '@salesforce/apex/x7sEventsListController.getTopics';

import labelSelectAll 				from '@salesforce/label/c.x7sEventFiltersLabelSelectAll';
import labelFromDate 				from '@salesforce/label/c.x7sEventsFilterLabelFromDate';
import labelToDate 					from '@salesforce/label/c.x7sEventsFilterLabelToDate';
import labelDescriptionClearDate 	from '@salesforce/label/c.x7sEventsFilterDescClearDate';
import labelPlaceholderLocation 	from '@salesforce/label/c.x7sEventsFilterPlaceholderLocation';
import labelTypeaheadlocation 		from '@salesforce/label/c.x7sEventsFilterLabelTypeaheadlocation';
import labelSearchLocation 			from '@salesforce/label/c.x7sEventsFilterLabelSearchLocation';
import labelEventypefilter 			from '@salesforce/label/c.x7sEventsFilterLabelEventypefilter';
import labelTopicAddNew 			from '@salesforce/label/c.x7sEventFilterTopicAddNew';
import labelTopicFilter 			from '@salesforce/label/c.x7sEventsFilterLabelTopic';

export default class X7sEventsFilters extends LightningElement {

    @api listId = "ID_1";
    @api showDateFilter = false;
    @api showTopicFilter = false;
    @api showTypeFilter = false;
    @api showLocationFilter = false;
    @api searchThreshold = 2;
    @api showPickLists = false;

    @api customField1 = "";
    @api labelCustomField1 = "";
    @api placeHolderCustomField1 = "";
	@api pickListLabelField1 = "";
	searchCustomField1 = "";
	typeAheadField1 = "";
	customValuesField1;

    @api customField2 = "";
    @api labelCustomField2 = "";
    @api placeHolderCustomField2 = "";
	@api pickListLabelField2 = "";
	searchCustomField2 = "";
	typeAheadField2 = "";
	customValuesField2;

    @api customField3 = "";
    @api labelCustomField3 = "";
    @api placeHolderCustomField3 = "";
	@api pickListLabelField3 = "";
	searchCustomField3 = "";
	typeAheadField3 = "";
	customValuesField3;

	error;
	searchString = "";
    selectAll = labelSelectAll;
	locationTypeAhead = "";
	locationValues = [];
	locationFilter = "";
	eventTypeValues;
	eventTypeFilter = "";
	addTolabel;
	eventsTopics = [];
	selectedTopicIds = [];
	fromDate;
	toDate;
	disableClear = true;
	disableDateClear = true;
	listViewMode = 'List';
	

    @wire(CurrentPageReference) pageRef;

    labels = {
		labelFromDate,
		labelToDate,
		labelDescriptionClearDate,
		labelPlaceholderLocation,
		labelTypeaheadlocation,
		labelSearchLocation,
		labelEventypefilter,
		labelTopicAddNew,
		labelTopicFilter
	}
	
    connectedCallback(){
		this.getPicklists();

		if(this.showTopicFilter){
			this.getTopicValues();
		}

		if(this.showTypeFilter){
			this.getEventTypeValues();
		}
		registerListener("listdefaultview", this.handleDefaultListView, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	handleDefaultListView(event) {
		if (this.listId === event.id) {
			//this.defaultView = event.value === 'vertical' ? 'Tile' : 'List';
			this.listViewMode = event.value === 'vertical' ? 'tile' : event.value === 'calendar' ? 'calendar'  : 'list';
		}
	}

	get customField1HasVal(){
		return (this.customField1 !== '' && this.customField1 !== null);
	}

	get customField2HasVal(){
		return (this.customField2 !== '' && this.customField2 !== null);
	}

	get customField3HasVal(){
		return (this.customField3 !== '' && this.customField3 !== null);
	}

	get isCalendarView(){
		return this.listViewMode === 'calendar';
	}

	getTopicValues(){
		getTopics()
		.then(result => {
			let data = result;
			let res = Object.keys(data).map((key) => {
				return ({name: data[key], id: key});
			});
			this.eventsTopics=res;
		})
		.catch(error => {
			this.error = error[0];
		});
	}

	getEventTypeValues(){
		getEventTypeList()
		.then(result=>{
			let data = result;
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({label: this.selectAll,value: ''});
			this.eventTypeValues = res;
		})
		.catch(error=>{
			this.error = error[0];
		})
	}

	handleTopicChangeEvent(event) {
        this.selectedTopicIds = event.detail;
        this.sendFilterEvent();
	}

	sendFilterEvent(){
        let _selectedItemIds = this.selectedTopicIds;
		let _selection = '';
	    for(let i=0;i<_selectedItemIds.length;i++) {
	        if(i === (_selectedItemIds.length -1))
	            _selection += _selectedItemIds[i];
	        else
	            _selection += _selectedItemIds[i] + ';';
        }
        fireEvent(this.pageRef, 'topicchangeevent', {id: this.listId, value: _selection});
    }
	
	customTypeAheadHandle(event) {
		let field = event.target.dataset.id;
		let pos = field.slice(-1);
		
		this.clearInvalidField(field);
		
		let searchString = event.target.value;

		if(searchString.length !== 0)
			this.disableClear = false;

		// Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
		window.clearTimeout(this.delayTimeout);
		this.delayTimeout = setTimeout(() => {
			let customField = this[`customField${pos}`];
			this.getEventPicklistValues(field, customField, `customValuesField${pos}`,searchString);
		
		}, custom.DELAY);
	}

	handleLocationTypeAhead(event){
		let fieldId = event.target.dataset.id;
		
		this.clearInvalidField(fieldId);
		
		let searchString = event.target.value;
		if(searchString.length !== 0)
			this.disableClear = false;

		window.clearTimeout(this.delayTimeout);
		this.delayTimeout = setTimeout(() => {
			this.getEventPicklistValues(
				fieldId,
				events.fields.location,
				'locationValues',
				searchString);
		}, custom.DELAY);
	}

	setInvalidField(fieldDataId) {
		this.template.querySelector(`[data-id="${fieldDataId}"]`).classList.add('slds-has-error');
	}
	
	clearInvalidField(fieldId) {
		this.template.querySelector(`[data-id="${fieldId}"]`).classList.remove('slds-has-error');
	}

    getEventPicklistValues(fielddataId, fieldName, valueSet, searchString){
    	getEventPickList(
		{
			fieldName: fieldName,
			searchString: searchString,
			valueSet 
		})
		.then(result => {
			let data = result;
			if (searchString.length && !data.length)
				this.setInvalidField(fielddataId);
			
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({label: this.selectAll,value: ''});
			
			this[valueSet] = res;
		})
		.catch(error => {
			this.error = error[0];
		});
	}
	
	getPicklists(){
		if(this.showPickLists){
			if(this.showLocationFilter){
				this.getEventPicklistValues(
					'locationTypeAhead',
					'Location_Name__c',
					this.locationValues,//this.locationValues
					'');
			}
			for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
				let customField = this[`customField${pos}`];
				if (customField && customField.length) {
					let dataId = this[`typeAheadCustomField${pos}`];
					this.getEventPicklistValues(dataId, customField, this[`customValuesField${pos}`], '');
				}
			}
		}
	}
	handleFilterEvent(event){
		let fieldId = event.target.dataset.id;
		let eventVal = event.target.value;

		if(fieldId === 'locationFilter' || fieldId === 'locationSearch')
			this.locationFilter = eventVal;
		if(fieldId === 'customField1Filter' || fieldId === 'customField1Search')
			this.searchCustomField1 = eventVal;
		if(fieldId === 'customField2Filter' || fieldId === 'customField2Search')
			this.searchCustomField2 = eventVal;
		if(fieldId === 'customField3Filter' || fieldId === 'customField3Search')
			this.searchCustomField3 = eventVal;
		if(fieldId === 'eventTypeFilter')
			this.eventTypeFilter = eventVal;
		if(fieldId === 'eventFromDate')
			this.fromDate = eventVal;
		if(fieldId === 'eventToDate')
			this.toDate = eventVal;
		this.fireSearchEvent(false);
	}

	fireSearchEvent(clearAll){
		let searchString = '';
		let threshold = this.searchThreshold; 

		if(this.showLocationFilter === true){
			if(this.locationFilter){
				let locationFilter = this.locationFilter;
				if(locationFilter.length > threshold && locationFilter !== this.selectAll){
					this.disableClear = false;
					searchString += events.fields.location + ':' + locationFilter + ';';
				}
			}
		}

		if(this.showTypeFilter === true){
			if(this.eventTypeFilter){
				let eventTypeFilter = this.eventTypeFilter;
				if(eventTypeFilter.length && eventTypeFilter !== this.selectAll)
					searchString += events.fields.eventType + ':' + eventTypeFilter + ';';
					this.disableClear = false;
			}
		}

		if(this.fromDate){
			this.disableClear = false;
			this.disableDateClear = false;
		}

		if(this.toDate){
			this.disableClear = false;
			this.disableDateClear = false;
		}

		let customfilterString = '';
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			// Custom fields
			let customField = this[`customField${pos}`];
			let customSearch = '';
			if (customField && customField.length) {
				customSearch += this[`searchCustomField${pos}`];
				if (customSearch.length && customSearch !== this.selectAll) {
					searchString += customField + ':' + customSearch + ';';
					customfilterString += customField + ':' + customSearch + ';';
					this.disableClear = false;
				}
			}
		}
		searchString = searchString.replace(/null:null;/g, '');

		this.disableClear = (searchString.length <= 3 && !this.fromDate && !this.toDate);
		this.disableDateClear = (!this.fromDate && !this.toDate);
		fireEvent(this.pageRef, 'applyfilterevent',
		{
			id: this.listId,
			filterValue : searchString,
			locationFilter : this.locationFilter,
			eventTypeFilter : this.eventTypeFilter,
			fromDate : this.fromDate,
			toDate : this.toDate,
			customfilterString : customfilterString,
			clearAll: clearAll
		});
	}

    // handlefromDateChange(event){
    //     this.fromDate = event.detail.value;
	// 	fireEvent(this.pageRef, 'eventfromdatechange',
	// 	{
	// 		id: this.listId, 
	// 		value: this.fromDate
	// 	});
	// 	if(this.fromDate){
	// 		this.disableDateClear = false;
	// 		this.disableClear = false;
	// 	}
    // }

    // handletoDateChange(event){
    //     this.toDate = event.detail.value;
    //     fireEvent(this.pageRef, 'eventtodatechange',{id: this.listId, value: this.toDate});
	// 	if(this.toDate){
	// 		this.disableDateClear = false;
	// 		this.disableClear = false;
	// 	}
    // }

    clearDates(){
        this.fromDate = '';
        this.toDate='';
        //fireEvent(this.pageRef, 'eventfromdatechange',{id: this.listId, value: this.fromDate});
        //fireEvent(this.pageRef, 'eventtodatechange',{id: this.listId, value: this.toDate});
		this.fireSearchEvent(true);
		this.disableDateClear = true;
	}

	clearAll() {
		this.eventTypeFilter = "";
		this.disableClear = true; 
		this.locationFilter = "";
		this.locationTypeAhead = "";
		this.fromDate = "";
		this.toDate = "";
		this.disableDateClear = true;
		this.locationValues = [];

		const inputFields = this.template.querySelectorAll('lightning-input');
		if (inputFields) {
            inputFields.forEach(field => {
                field.value = '';
            });
		}
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			this[`typeAheadField${pos}`] = "";
			this[`searchCustomField${pos}`] = "";
			this[`customValuesField3${pos}`] = [];
		}
		this.getPicklists();
		this.fireSearchEvent(true);
	}
}