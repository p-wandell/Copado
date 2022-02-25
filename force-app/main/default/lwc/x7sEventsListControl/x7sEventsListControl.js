/*
 * Copyright (c) 2020. 7summits Inc. All rights reserved.
 */
import { LightningElement, api, wire } from 'lwc';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";
import {inLexMode} from 'c/x7sShrUtils';

import labelUpcoming from '@salesforce/label/c.x7sEventsListControlLabelUpcoming';
import labelTopAttendance from '@salesforce/label/c.x7sEventsListControlLabelTopAttendance';
import titleViewCard from '@salesforce/label/c.x7sShrTitleViewCard';
import titleViewList from '@salesforce/label/c.x7sShrTitleViewList';
import altViewCard from '@salesforce/label/c.x7sShrLabelAltViewCard';
import altViewList from '@salesforce/label/c.x7sShrLabelAltViewList';
import labelCalenderView from '@salesforce/label/c.x7sEventsListControlLabelCalendar';

export default class X7sEventsListControl extends LightningElement {

    //Design Properties
    @api sortBy = "Upcoming";
    @api showSort = false;
    @api showViewOptions = false;
    @api listId = 'ID_1';
	@api showPagination = false;
	@api sortVariant = "standard";
	@api customClass = "";

    hasNext = false;
	hasPrevious = false;
	hideViewSelector = true;
	defaultView;
	handleViewMode;

	labels = {
		titleViewCard,
		titleViewList,
		altViewCard,
		altViewList,
		labelCalenderView
	}
	
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
		registerListener("listdefaultview", this.handleDefaultListView, this);
	}

	renderedCallback(){
        fireEvent(this.pageRef, 'sortbyevent', {id: this.listId, value: this.sortBy});
    }
    
    disconnectedCallback() {
		unregisterAllListeners(this);
	}

	get viewOptionClass(){
		return (inLexMode() && this.defaultView === 'calendar') ? 'addPadding addTopPadding' : inLexMode() ? 'addPadding slds-m-right_small' : 'slds-m-right_small';
	}

	get bodyClass(){
		return inLexMode() ? 'slds-grid slds-grid_vertical-align-end slds-wrap slds-card' : 'slds-grid slds-grid_vertical-align-end slds-wrap';
	}
	
	get isCalendarView(){
		return this.defaultView === 'calendar';
	}

    get hideSort(){
        return !this.showSort;
	}
	
	get hidePagination(){
		return !this.showPagination;
	}

    get sortOptions(){
        return [
            {label : labelUpcoming, value : "Upcoming"},
            {label : labelTopAttendance, value : "Top Attendance"}
        ];
    }

	get listVariant() {
		return this.defaultView === 'list' ? 'brand' : 'neutral';
	}

	get tileVariant() {
		return this.defaultView === 'tile' ? 'brand' : 'neutral';
	}

	get calenderVariant() {
		return this.defaultView === 'calendar' ? 'brand' : 'neutral';
	}

	handleDefaultListView(event) {
		if (this.listId === event.id) 
			this.defaultView = event.value === 'vertical' ? 'tile' : event.value === 'calendar' ? 'calendar'  : 'list';
	}

	handleListView() {
		this.defaultView = 'list';
		fireEvent(this.pageRef, 'listviewoption', {id: this.listId});
	}
	
	handleCardView() {
		this.defaultView = 'tile';
		fireEvent(this.pageRef, 'cardviewoption', {id: this.listId});
	}

	handleCalenderView() {
		this.defaultView = 'calendar';
		fireEvent(this.pageRef, 'calendarviewoption', {id: this.listId});
	}
}