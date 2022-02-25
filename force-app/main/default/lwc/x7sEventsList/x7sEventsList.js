/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import {api, LightningElement, wire, track} from 'lwc';

import {CurrentPageReference} from 'lightning/navigation';
import {custom, events, updateEventItem} from 'c/x7sEventsBase';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import getEventsList from '@salesforce/apex/x7sEventsListController.getEventsList';
import getSitePrefix from '@salesforce/apex/x7sEventsListController.getSitePrefix';
import previousPageList from '@salesforce/apex/x7sEventsListController.previousPageList';
import nextPageList from '@salesforce/apex/x7sEventsListController.nextPageList';
import x7sEventsListEmpty from '@salesforce/label/c.x7sEventsListEmpty';

export default class X7sEventsList extends LightningElement {
	
	@api recordId;
	@api numberofresults;
	@api listSize = 50;
	@api showEventType = false;
	@api filterOn = "None";
	@api filterEventsByTopic = "";
	@api limitToSpecificGroups = false;
	@api showImages = false;
	@api showImagesAsAvatar = false;
	@api showTopics = "true";
	@api tileVariant = 'default';
	@api layout = 'vertical';
	@api listId = "ID_1";
	@api customClass;
	@api eventListIds = "";
	
	@api customLabel1 = "";
	@api customField1 = "";
	@api customLabel2 = "";
	@api customField2 = "";
	@api customLabel3 = "";
	@api customField3 = "";
	
	@api hiddenFilter1 = "";
	@api hiddenValue1 = "";
	@api hiddenFilter2 = "";
	@api hiddenValue2 = "";
	@api hiddenFilter3 = "";
	@api hiddenValue3 = "";
	
	@api eventDetailURL = "/event/";
	@api listViewPageUrl = "/event-list-view-page/";
	
	error;
	sitePrefix;
	searchstr = "";
	isConCallbackExecuted = false;
	filterByTopic;
	eventsListWrapper;
	showEmptyLabel = false;
	filterType;
	sortBy = "Upcoming";
	currentURL;
	listViewMode = "List";
	layoutClass = 'slds-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_4-of-12';
	listViewClass = 'slds-size_12-of-12';
	loading = true;
	@track listofEventIds = [];
	
	//from Filters
	topicOrGrpValue;
	eventTypeFilter = "";
	locationFilter = "";
	customFilter = "";
	fromDate = "";
	toDate = "";
	
	//from Wrapper
	totalEvents;
	pageNumber;
	totalPages;
	hasPreviousSet;
	hasNextSet;
	
	labelEmptyList = x7sEventsListEmpty;
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		
		let url = window.location.href;
		let urlParts = url.split(/[\/?]/);
		let start = 0;
		this.currentURL = encodeURIComponent(url);
		
		for (; start < urlParts.length; start++) {
			if (urlParts[start] === 's')
				break;
		}
		let recordId = this.recordId;
		let urlTarget = urlParts[start + 1];
		let filterValue = urlParts[start + 2];
		let filterName = urlParts[start + 3];
		let filterOn = this.filterOn;
		
		if (this.filterOn === "Search Term") {
			this.searchstr = filterValue;
		} else if (filterOn === "Topic Value") {
			this.topicOrGrpValue = filterName;
		} else if (filterOn === "Group") {
			this.topicOrGrpValue = filterValue;
		}
		else if (filterOn.indexOf('My Events') !== -1) {
			if (filterOn.indexOf(':') === -1 && urlTarget === 'profile' && recordId) {
				this.filterOn = filterOn + ':' + recordId;
			}
		}
		let filterByTopic = this.filterEventsByTopic;
		if (filterByTopic !== undefined && filterByTopic !== '') {
			this.filterByTopic = filterByTopic;
			this.topicOrGrpValue = filterByTopic;
		}
		if(this.eventListIds && this.eventListIds.length >0){
			let listofEventIds = [];
		 	listofEventIds = this.eventListIds.split(",");
		 	listofEventIds.forEach(function (Id, index) {
				 Id = Id.trim();
				 this.listofEventIds.push(Id);
			}.bind(this));
		}

		this.getSitePrefix();
		
		if (!this.isConCallbackExecuted) {
			this.getEvents();
		}
		
		this.isConCallbackExecuted = true;
		
		registerListener("topicchangeevent", this.handleTopicChange, this);
		registerListener("applyfilterevent", this.handleFilters, this);
		registerListener("listviewoption", this.handleListView, this);
		registerListener("sortbyevent", this.handleSortByEvent, this);
		registerListener("calendarviewoption", this.handleCalendarView, this);
		registerListener("cardviewoption", this.handleCardView, this);
		registerListener("pageprevious", this.handlePrevious, this);
		registerListener("pagenext", this.handleNext, this);
		registerListener("searchstring",    this.handleSearchString, this);
		registerListener("calendartotalevents", this.handleCalendarTotalEvents, this);
	}
	
	renderedCallback() {
		if (this.isCalendarView) {
			return;
		}

		fireEvent(this.pageRef, 'totalevents', {id: this.listId, value: this.totalEvents});
		fireEvent(this.pageRef, 'listhasnext', {id: this.listId, value: this.hasNextSet});
		fireEvent(this.pageRef, 'listhasprevious', {id: this.listId, value: this.hasPreviousSet});
		fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.pageNumber});
		fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.totalPages});
		fireEvent(this.pageRef, 'listdefaultview', {id: this.listId, value: this.layout});
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get componentClass() {
		return `x7s-groups-list ${this.customClass}`;
	}
	
	get viewSelectorStyle() {
		return (this.layout !== 'horizontal') ? `${this.layoutClass}` : `${this.listViewClass}`;
	}
	
	get cardTextAlign() {
		return this.layout === 'vertical' ? 'center' : 'left';
	}
	
	get showAvatar() {
		return this.showImages && this.showImagesAsAvatar;
	}
	
	get isCalendarView() {
		return this.layout === 'calendar';
	}
	
	setDisplayMode(evt) {
		if (this.listId === evt.id) {
			this.listViewMode = evt.value;
		}
	}
	
	handleFilters(event) {
		if (!this.isConCallbackExecuted) {
			return;
		}
		
		if (this.listId === event.id) {
			this.locationFilter = event.locationFilter
			this.eventTypeFilter = event.eventTypeFilter
			this.fromDate = event.fromDate;
			this.toDate = event.toDate;
			this.customFilter = event.customfilterString;
			this.getEvents();
		}
	}
	
	handleTopicChange(event) {
		if (!this.isConCallbackExecuted) {
			return;
		}
		if (this.listId === event.id) {
			this.filterByTopic = event.value;
			this.getEvents();
		}
	}
	
	handleCardView(evt) {
		if (this.listId === evt.id) {
			this.layout = 'vertical';
			this.listViewMode = 'Tile';
		}
	}
	
	handleListView(evt) {
		if (this.listId === evt.id) {
			this.layout = 'horizontal';
			this.listViewMode = 'List';
		}
	}
	
	handleCalendarView(evt) {
		if (this.listId === evt.id) {
			this.layout = 'calendar';
			this.listViewMode = 'Calendar';
		}
	}
	
	handleSortByEvent(evt) {
		if (this.listId === evt.id) {
			this.sortBy = evt.value;
			this.getEvents();
		}
	}

	handleSearchString(evt) {
		if (this.listId === evt.id) {
			this.searchstr = evt.value;
			this.getEvents();
		}
	}
	
	//pagination handlers
	handlePrevious(evt) {
		if (this.listId === evt.id) {
			previousPageList(this.getEventParams())
				.then(result => {
					this.processData(result);
				})
				.catch(error => {
					console.log("Error occurred after clicking Previous button:" + error);
				});
		}
	}
	
	handleNext(evt) {
		if (this.listId === evt.id) {
			nextPageList(this.getEventParams())
				.then(result => {
					this.processData(result);
				})
				.catch(error => {
					console.log("Error occurred after clicking next button:" + error);
				});
		}
	}

	handleCalendarTotalEvents(event) {
		if (this.listId === event.id && this.isCalendarView) {
			fireEvent(this.pageRef, 'totalevents', {id: event.id, value: event.value});
		}
	}

	getEventParams() {
		const regex = /;/gi;
		let topicList = this.filterByTopic;
		if (topicList)
			topicList = this.filterByTopic.replace(regex, ',');
		
		const paramSet = {
			compactMode: false,
			recordSize: this.numberofresults,
			listSize: this.listSize,
			strFilterType: this.filterType,
			sortBy: this.sortBy,
			filterByTopic: topicList,
			topicName: this.topicOrGrpValue,
			searchTerm: this.searchstr,
			filterOn: this.filterOn,
			fromDate: this.fromDate,
			toDate: this.toDate,
			listViewMode: this.listViewMode,
			customFields: this.getCustomFields(),
			filters: this.getFilterString(),
			pageNumber: this.pageNumber,
			eventIdList:this.listofEventIds
		};
		
		console.log("listViewMode   :" + this.listViewMode);
		return paramSet;
	}
	
	getSitePrefix() {
		getSitePrefix()
			.then(result => {
				this.sitePath = result;
				let position = this.sitePath.lastIndexOf('/s');
				this.sitePrefix = this.sitePath.substring(0, position);
			})
			.catch(error => {
				this.error = error;
			});
	}
	
	getEvents() {
		this.loading = true;

		getEventsList(this.getEventParams())
		.then(result => {
			this.loading = false;
			this.processData(result);
		})
		.catch(error => {
			this.loading = false;
			console.log("Error occurred while getting events:" + JSON.stringify(error));
		})
	}
	
	getCustomFields() {
		let customFields = '';
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			if (customField && customField.length) {
				customFields += customField + ',';
			}
		}
		return customFields;
	}
	
	getHiddenFilters() {
		let filterString = '';
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`hiddenFilter${pos}`];
			if (customField && customField.length) {
				let customSearch = this[`hiddenValue${pos}`];
				
				if (customSearch && customSearch.length) {
					filterString += customField + ':' + customSearch + ';';
				}
			}
		}
		return filterString;
	}
	
	getFilterString() {
		let filterString = this.getHiddenFilters();
		
		let typeFilter = this.eventTypeFilter;
		if (typeFilter) {
			filterString += events.fields.eventType;
			filterString += custom.SEARCH_FIELD;
			filterString += typeFilter;
			filterString += custom.SEARCH_SEPARATOR;
		}
		
		let locationFilter = this.locationFilter;
		if (locationFilter) {
			filterString += events.fields.location;
			filterString += custom.SEARCH_FIELD;
			filterString += locationFilter;
			filterString += custom.SEARCH_SEPARATOR;
		}
		
		let customFilter = this.customFilter;
		if (customFilter) {
			filterString += customFilter;
		}
		
		return filterString;
	}
	
	processData(data) {
		this.eventsListWrapper = this.updateEventsWrapper(data);
		this.pageNumber = this.eventsListWrapper.pageNumber;
		this.totalPages = this.eventsListWrapper.totalPages;
		this.hasPreviousSet = this.eventsListWrapper.hasPreviousSet;
		this.hasNextSet = this.eventsListWrapper.hasNextSet;
		this.totalEvents = this.eventsListWrapper.totalResults;
	}
	
	updateEventsWrapper(eventsListWrapper) {
		
		for (let i = 0; i < eventsListWrapper.objEventList.length; i++) {
			let eventItem = updateEventItem(eventsListWrapper.objEventList[i]);
			
			eventItem.topics1 = [];
			eventItem.topics1.push(eventsListWrapper.eventsToTopicsMap[eventItem.Id]);
			eventItem.topics = [];
			
			if (eventItem.topics1) {
				for (let j = 0; j < eventItem.topics1.length; j++) {
					if (eventItem.topics1[j] !== undefined) {
						for (let jj = 0; jj < eventItem.topics1[j].length; jj++) {
							eventItem.topics.push(eventItem.topics1[j][jj]);
						}
					}
				}
				eventItem.topics.sort((a, b) => {
					const nameA = a.Topic.Name.toUpperCase(); // ignore upper and lowercase
					const nameB = b.Topic.Name.toUpperCase(); // ignore upper and lowercase
					if (nameA < nameB) {
						return -1;
					}
					if (nameA > nameB) {
						return 1;
					}
					// names must be equal
					return 0;
				});
			}
			this.setCustomFields(eventsListWrapper.objEventList, i);
			eventItem.imageURL = eventsListWrapper.eventIdtoimageURLMap[eventItem.Id];
		}
		this.showEmptyLabel = eventsListWrapper && eventsListWrapper.objEventList.length === 0;
		
		return eventsListWrapper;
	}
	
	setCustomFields(objEventList, index) {
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			
			if (customField && customField.length) {
				let fieldSet = true;
				let fieldParts = customField.split('.');
				let fieldValue = objEventList[index];
				
				for (let part = 0; part < fieldParts.length; part++) {
					if (fieldValue[fieldParts[part]])
						fieldValue = fieldValue[fieldParts[part]];
					else {
						fieldSet = false;
						break;
					}
				}
				objEventList[index]['customField' + pos] = fieldSet ? fieldValue : '';
			}
		}
	}
}