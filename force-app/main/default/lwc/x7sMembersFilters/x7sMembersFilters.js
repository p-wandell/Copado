/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, LightningElement, track, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";

import {fireEvent, registerListener, unregisterAllListeners} from "c/x7sShrUtils";
import {changeContactToUserFields, contact, custom} from "c/x7sMembersBase";

import getMemberPicklist from "@salesforce/apex/x7sMembersController.getMemberPicklist";
import get_topicValues from "@salesforce/apex/x7sMembersController.getTopicValues";

import labelTextSelectAll from "@salesforce/label/c.x7sMembersTextSelectAll";
import labelSearchLastName from "@salesforce/label/c.x7sMembersLabelSearchLastName";
import labelButtonClearAll from "@salesforce/label/c.x7sMembersLabelButtonClearAll";
import labelClearAll from "@salesforce/label/c.x7sMembersTooltipClearAll";
import labelSearchTopics from "@salesforce/label/c.x7sMembersLabelSearchTopics";
import labelPlaceholderTitle from "@salesforce/label/c.x7sMembersLabelPlaceholderTitle";
import labelTypeAheadTitle from "@salesforce/label/c.x7sMembersLabelTypeAheadTitle";
import labelSearchTitle from "@salesforce/label/c.x7sMembersLabelSearchTitle";
import labelPlaceholderCountry from "@salesforce/label/c.x7sMembersLabelPlaceholderCountry";
import labelTypeAheadCountry from "@salesforce/label/c.x7sMembersLabelTypeAheadCountry";
import labelSearchCountries from "@salesforce/label/c.x7sMembersLabelSearchCountries";
import labelPlaceholderState from "@salesforce/label/c.x7sMembersLabelPlaceholderState";
import labelTypeAheadState from "@salesforce/label/c.x7sMembersLabelTypeAheadState";
import labelSearchStates from "@salesforce/label/c.x7sMembersLabelSearchStates";
import labelPlaceholderCity from "@salesforce/label/c.x7sMembersLabelPlaceholderCity";
import labelTypeAheadCity from "@salesforce/label/c.x7sMembersLabelTypeAheadCity";
import labelSearchCities from "@salesforce/label/c.x7sMembersLabelSearchCities";
import labelPlaceholderAccount from "@salesforce/label/c.x7sMembersLabelPlaceholderAccount";
import labelTypeAheadAccount from "@salesforce/label/c.x7sMembersLabelTypeAheadAccount";
import labelSearchAccounts from "@salesforce/label/c.x7sMembersLabelSearchAccounts";
import labelAriaWrapper  from '@salesforce/label/c.x7sMembersAriaLabelWrapper';

export default class X7sMembersFilters extends LightningElement {
	
	@api listId;
	@api customClass;
	@api compactView="false";
	@api showClearAll="true";
	@api searchString = '';
	@api searchThreshold="2";
	@api searchFields='';
	@api enableLastNameSearch="false";
	@api searchLastName;
	@api labelMembersFollow='Members I Follow';
	@api showPicklists="false";     // Global show pick lists setting
	@api useContact="true";        // Contact record fields
	@api showTitleFilter="false";
	@api titleSearch = '';
	@api titleTypeAhead = '';
	
	@api showCountryFilter="false";
	@api countryValues = [];
	@api countrySearch = '';
	@api countryTypeAhead = '';
	
	@api showStateFilter="false";
	@api stateValues = [];
	@api stateSearch = '';
	@api stateTypeAhead = '';
	
	@api showCityFilter="false";
	@api cityValues = [];
	@api citySearch = '';
	@api cityTypeAhead = '';
	
	@api showAccountFilter="false";
	@api accountValues = [];
	@api accountSearch = '';
	@api accountTypeAhead = '';
	
	@api showTopicFilter="false";
	@api topicValues = [];
	@api topicSearch = '';
	
	// Custom Field1
	@api customField1='';
	@api labelCustomField1='';
	@api placeHolderCustomField1='';
	@api searchCustomField1 = '';
	@api pickListLabelField1='';
	@api customValuesField1 = [];
	@api typeAheadField1 = '';
	
	// Custom Field2
	@api customField2='';
	@api labelCustomField2='';
	@api placeHolderCustomField2='';
	@api searchCustomField2 = '';
	@api pickListLabelField2='';
	@api customValuesField2 = [];
	@api typeAheadField2 = '';
	
	// Custom Field3
	@api customField3='';
	@api labelCustomField3='';
	@api placeHolderCustomField3='';
	@api searchCustomField3 = '';
	@api pickListLabelField3='';
	@api customValuesField3 = [];
	@api typeAheadField3 = '';
	
	// Custom Field4
	@api customField4='';
	@api labelCustomField4='';
	@api placeHolderCustomField4='';
	@api searchCustomField4 = '';
	@api pickListLabelField4='';
	@api customValuesField4 = [];
	@api typeAheadField4 = '';
	
	// Custom Field5
	@api customField5='';
	@api labelCustomField5='';
	@api placeHolderCustomField5='';
	@api searchCustomField5 = '';
	@api pickListLabelField5='';
	@api customValuesField5 = [];
	@api typeAheadField5 = '';
	
	// Custom Field6
	@api customField6='';
	@api labelCustomField6='';
	@api placeHolderCustomField6='';
	@api searchCustomField6 = '';
	@api pickListLabelField6='';
	@api customValuesField6 = [];
	@api typeAheadField6 = '';
	
	@api selectAll = labelTextSelectAll;
	
	@track showMyMembers = false;
	@track isSearchText = false;
	@track showMembersFollow = true;
	@track showSearch = true;
	@track titleValues = [];
	@track disableClear = true;
	
	@wire(CurrentPageReference) pageRef;
	
	labels = {
		labelTextSelectAll,
		labelSearchLastName,
		labelButtonClearAll,
		labelClearAll,
		labelSearchTopics,
		labelTypeAheadTitle,
		labelPlaceholderTitle,
		labelSearchTitle,
		labelPlaceholderCountry,
		labelTypeAheadCountry,
		labelSearchCountries,
		labelPlaceholderState,
		labelTypeAheadState,
		labelSearchStates,
		labelPlaceholderCity,
		labelTypeAheadCity,
		labelSearchCities,
		labelPlaceholderAccount,
		labelTypeAheadAccount,
		labelSearchAccounts,
		labelAriaWrapper
	};
	
	connectedCallback() {
		if (!this.useContact) {
			changeContactToUserFields();
		}
		this.getPicklists();
		// this.getTopicValues();
		registerListener("searchstring", this.handleSearchString, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get componentClass() {
		return 'x7s-members-filters ' + this.showTheme ? `${this.customClass} slds-theme_default` : `${this.customClass}`;
	}
	
	get compactView_12_3() {
		return (this.compactView === true) ? "12" : "3";
	}
	
	get compactView_12_6() {
		return (this.compactView) ? "12" : "6";
	}
	
	get customField1val() {
		return (this.customField1 !== '' && this.customField1 !== null);
	}
	
	get customField2val() {
		return (this.customField2 !== '' && this.customField2 !== null);
	}
	
	get customField3val() {
		return (this.customField3 !== '' && this.customField3 !== null);
	}
	
	get customField4val() {
		return (this.customField4 !== '' && this.customField4 !== null);
	}
	
	get customField5val() {
		return (this.customField5 !== '' && this.customField5 !== null);
	}
	
	get customField6val() {
		return (this.customField6 !== '' && this.customField6 !== null);
	}
	
	handleSearchString(evt) {
		if (this.listId === evt.id) {
			let threshold = this.searchThreshold;
			let tempString = evt.value;
			let searchLastFirst = this.searchLastName;
			this.searchString = tempString;
			if (!searchLastFirst && (this.searchString.length === 0 || this.searchString.length >= threshold)) {
				this.fireSearchEvent();
			}
		}
	}
	
	changeFilterHandler(event) {
		let fieldId = event.target.dataset.id;
		let eventVal = event.target.value;
		if (fieldId === 'myMember') {
			this.showMyMembers = event.target.checked;
		}
		if (fieldId === 'topicFilter') {
			this.topicSearch = eventVal;
		}
		if (fieldId === 'titleFilter' || fieldId === 'titleSearch') {
			this.titleSearch = eventVal;
		}
		
		if (fieldId === 'countryFilter' || fieldId === 'countrySearch') {
			this.countrySearch = eventVal;
		}
		
		if (fieldId === 'stateFilter' || fieldId === 'stateSearch') {
			this.stateSearch = eventVal;
		}
		
		if (fieldId === 'cityFilter' || fieldId === 'citySearch') {
			this.citySearch = eventVal;
		}
		
		if (fieldId === 'accountFilter' || fieldId === 'accountSearch') {
			this.accountSearch = eventVal;
		}
		if (fieldId === 'customField1Filter') {
			this.searchCustomField1 = eventVal;
		}
		if (fieldId === 'customField2Filter') {
			this.searchCustomField2 = eventVal;
		}
		if (fieldId === 'customField3Filter') {
			this.searchCustomField3 = eventVal;
		}
		if (fieldId === 'customField4Filter') {
			this.searchCustomField4 = eventVal;
		}
		if (fieldId === 'customField5Filter') {
			this.searchCustomField5 = eventVal;
		}
		if (fieldId === 'customField6Filter') {
			this.searchCustomField1 = eventVal;
		}
		this.fireSearchEvent(false);
	}
	
	fireSearchEvent(clearAll) {
		let threshold = this.searchThreshold;
		let selectAll = this.selectAll;
		let searchString = this.searchString;
		let searchFields = this.searchFields;
		let myMembers = this.showMyMembers;
		let topicString = '';
		
		if (this.searchLastName === true) {
			let searchNameParts = searchString.split(',');
			
			// ignore regular search
			searchString = ':;';
			
			if (searchNameParts && searchNameParts.length) {
				if (searchNameParts[0].trim().length > 0) {
					searchString += contact.fields.lastName + ':' + searchNameParts[0].trim() + ';';
					
					if (searchNameParts.length > 1) {
						searchString += contact.fields.firstName + ':' + searchNameParts[1].trim() + ';';
					}
				}
			}
		} else {
			searchString += ':';
			searchString += searchString.length > 1 ? searchFields : '';
			searchString += ';';
		}
		
		if (this.showTitleFilter === true) {
			let titleSearch = this.titleSearch;
			
			if (titleSearch.length >= threshold && titleSearch !== selectAll) {
				searchString += contact.fields.title + ':' + titleSearch + ';';
			}
		}
		
		if (this.showCountryFilter === true) {
			let countrySearch = this.countrySearch;
			
			if (countrySearch.length >= threshold && countrySearch !== selectAll) {
				searchString += contact.fields.country + ':' + countrySearch + ';';
			}
		}
		
		if (this.showStateFilter === true) {
			let stateSearch = this.stateSearch;
			
			if (stateSearch.length >= threshold && stateSearch !== selectAll) {
				searchString += contact.fields.state + ':' + stateSearch + ';';
			}
		}
		
		if (this.showCityFilter === true) {
			let citySearch = this.citySearch;
			
			if (citySearch.length >= threshold && citySearch !== selectAll) {
				searchString += contact.fields.city + ':' + citySearch + ';';
			}
		}
		
		if (this.showAccountFilter === true) {
			let accountSearch = this.accountSearch;
			
			if (accountSearch.length >= threshold && accountSearch !== selectAll) {
				searchString += contact.fields.account + ':' + accountSearch + ';';
			}
		}
		
		if (this.showTopicFilter === true) {
			let topicSearch = this.topicSearch;
			
			if (topicSearch.length && topicSearch !== selectAll) {
				topicString = topicSearch;
			}
		}
		
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			// Custom field
			let customField = this[`customField${pos}`];
			let customSearch = '';
			if (customField && customField.length) {
				customSearch += this[`searchCustomField${pos}`];
				if (customSearch.length && customSearch !== selectAll) {
					searchString += customField + ':' + customSearch + ';';
				}
			}
		}
		
		searchString = searchString.replace(/null:null;/g, '');
		
		console.log('fireSearchEvent:');
		console.log('    searchString   : ' + searchString);
		console.log('    topicString    : ' + topicString);
		console.log('    searchMyMembers: ' + myMembers);
		
		// the empty search = '::;'
		this.disableClear = (searchString.length <= 3 && topicString === '' && !myMembers);
		
		fireEvent(this.pageRef, "memberfilterevent", {
			id: this.listId,
			searchString: searchString,
			topicString: topicString,
			searchMyMembers: myMembers ? 'true' : '',
			clearAll: clearAll
		});
	}
	
	handleEnableLastFirst(event) {
		this.searchLastName = event.target.checked;
		if (this.searchLastName) {
			this.template.querySelector(`[data-id="searchLastFirstButton"]`).classList.remove("slds-hide");
		} else {
			this.template.querySelector(`[data-id="searchLastFirstButton"]`).classList.add('slds-hide');
		}
	}
	
	searchLastFirstName() {
		this.fireSearchEvent();
	}
	
	clearAll() {
		this.showMyMembers = false;
		this.searchString = '';
		this.disableClear = true;
		this.titleSearch = '';
		this.countrySearch = '';
		this.stateSearch = '';
		this.citySearch = '';
		this.accountSearch = '';
		this.topicSearch = '';
		this.titleTypeAhead = '';
		this.countryTypeAhead = '';
		this.stateTypeAhead = '';
		this.cityTypeAhead = '';
		this.accountTypeAhead = '';
		
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			this[`typeAheadField${pos}`] = '';
			this[`searchCustomField${pos}`] = '';
		}
		
		this.getPicklists();
		this.fireSearchEvent(true);
		
	}
	
	getPicklists() {
		if (this.showPicklists) {
			if (this.showTitleFilter) {
				this.getMemberPicklistValues(
					contact.dataId.title,
					contact.fields.title,
					contact.values.title,
					'');
			}
			
			if (this.showCountryFilter) {
				this.getMemberPicklistValues(
					contact.dataId.country,
					contact.fields.country,
					contact.values.country,
					'');
			}
			
			if (this.showStateFilter) {
				this.getMemberPicklistValues(
					contact.dataId.state,
					contact.fields.state,
					contact.values.state,
					'');
			}
			
			if (this.showCityFilter) {
				this.getMemberPicklistValues(
					contact.dataId.city,
					contact.fields.city,
					contact.values.city,
					'');
			}
			
			if (this.showAccountFilter) {
				this.getMemberPicklistValues(
					contact.dataId.account,
					contact.fields.account,
					contact.values.account,
					'');
			}
			
			for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
				let customField = this[`customField${pos}`];
				if (customField && customField.length) {
					let dataId = this[`typeAheadCustomField${pos}`];
					this.getMemberPicklistValues(dataId, customField, `customValuesField${pos}`, '');
				}
			}
		}
		
		if (this.showTopicFilter) {
			this.getTopicValues();
		}
	}
	
	getTopicValues() {
		get_topicValues()
			.then(result => {
				//this.topicValues=result;
				let data = result;
				let res = Object.keys(data).map((key) => {
					
					// Using Number() to convert key to number type
					// Using obj[key] to retrieve key value
					
					return ({label: data[key], value: key});
				});
				res.unshift({
					label: this.selectAll,
					value: ''
				});
				this.topicValues = res;
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	getMemberPicklistValues(fielddataId, fieldName, valueSet, searchString) {
		getMemberPicklist(
			{
				fieldName: fieldName,
				searchString: searchString, valueSet
			})
			.then(result => {
				let data = result;
				console.log('-getMemberPicklist--'+data);
				if (searchString.length && !data.length) {
					this.setInvalidField(fielddataId);
				}
				
				let res = Object.keys(data).map((key) => {
					
					return ({label: data[key], value: data[key]});
				});
				res.unshift({
					label: this.selectAll,
					value: ''
				});
				
				this[valueSet] = res;
				
				console.log('Picklist (' + fieldName + ')');
				for (let [key, value] of result.entries()) {
					console.log(JSON.stringify(result[key]));
				}
			})
			.catch(error => {
				this.error = error[0];
			});
	}
	
	setInvalidField(fieldDataId) {
		this.template.querySelector(`[data-id="${fieldDataId}"]`).classList.add('slds-has-error');
	}
	
	clearInvalidField(fieldId) {
		this.template.querySelector(`[data-id="${fieldId}"]`).classList.remove('slds-has-error');
	}
	
	handleContactTypeAhead(event) {
		let fieldId = event.target.dataset.id;
		let lookup = fieldId.split('Type')[0];
		
		this.clearInvalidField(fieldId);
		
		let threshold = this.searchThreshold;
		let searchString = event.target.value;
		console.log('----fieldId----' + fieldId);
		console.log('----searchString----' + searchString);
		
		if (searchString.length === 0 || searchString.length >= threshold) {
			this.getMemberPicklistValues(
				fieldId,
				contact.fields[lookup],
				contact.values[lookup],
				searchString);
		}
	}
	
	customTypeAheadHandle(event) {
		let field = event.target.dataset.id;
		let pos = field.slice(-1);
		
		this.clearInvalidField(field);
		
		let threshold = this.searchThreshold;
		let searchString = event.target.value;
		console.log('--custom searchString---' + searchString);
		
		if (searchString.length === 0 || searchString.length >= threshold) {
			let customField = this[`customField${pos}`];
			console.log('--customField---' + customField);
			this.getMemberPicklistValues(
				field,
				customField,
				`customValuesField${pos}`,
				searchString);
		}
	}
	
	searchCustomFieldHandle(event) {
		let fieldId = event.target.dataset.id;
		let eventVal = event.target.value;
		let pos = event.target.name.slice(-1);
		let threshold = this.searchThreshold;
		let searchString = event.target.value;
		
		if (fieldId === `searchCustomField${pos}`) {
			this[`searchCustomField${pos}`] = eventVal;
		}
		
		if (searchString.length >= threshold) {
			this.fireSearchEvent(false);
		}
	}
}