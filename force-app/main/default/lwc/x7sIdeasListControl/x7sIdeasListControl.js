/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import { registerListener, unregisterAllListeners,fireEvent,inLexMode} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";

import ss_idea_label_PopularIdeas from '@salesforce/label/c.x7sIdeasListControlPopularIdeas';
import ss_idea_label_RecentIdeas from '@salesforce/label/c.x7sIdeasListControlRecentIdeas';
import ss_idea_label_TopAllTime from '@salesforce/label/c.x7sIdeasListControlTopAllTime';
import ss_idea_label_RecentComments from '@salesforce/label/c.x7sIdeasListControlRecentComments';
import labelAriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";
import titleViewCard from '@salesforce/label/c.x7sShrTitleViewCard';
import titleViewList from '@salesforce/label/c.x7sShrTitleViewList';
import altViewCard from '@salesforce/label/c.x7sShrLabelAltViewCard';
import altViewList from '@salesforce/label/c.x7sShrLabelAltViewList';
import altViewTable from '@salesforce/label/c.x7sIdeasLabelAltViewTable';
import titleViewTable from '@salesforce/label/c.x7sIdeasTitleViewTable';

export default class X7sIdeasListControl extends LightningElement {
	
	@api listId = 'ID_1';
	@api customClass = '';
	@api zoneName = 'Internal Zone';
	@api showViewSelector = "true";
	@api showSort = "true";
	@api sortOptions;
	@api sortVariant = 'standard';
	@api showPagination = "true";
	@api defaultSort = 'Popular Ideas';
	@api displayVariant = 'None'; 
	@api showTable = "true";
	@api showList = "true";
	@api showCard = "true";

	hasNext = false;
	hasPrevious = false;
	defaultView;

	labels = {
		labelAriaWrapper,
		titleViewCard,
		titleViewList,
		altViewCard,
		altViewList,
		altViewTable,
		titleViewTable
	}
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		registerListener("listdefaultview", this.handleDefaultListView, this);
	}
	disconnectedCallback() {
		unregisterAllListeners(this);
    }
	renderedCallback() {
		fireEvent(this.pageRef, 'sortbyevent', {id: this.listId, value: this.defaultSort});
	}
	get bodyClass(){
		return inLexMode() ? 'slds-grid slds-grid_vertical-align-end slds-wrap slds-card' : 'slds-grid slds-grid_vertical-align-end slds-wrap';
	}
	get hidePagination() {
		return !this.showPagination;
	}
	
	get hideSort() {
		return !this.showSort;
	}
	
	get hideViewSelector() {
		return !this.showViewSelector;
	}
	get listVariant() {
		return this.defaultView === 'List' ? 'brand' : 'neutral';
	}

	get tileVariant() {
		return this.defaultView === 'Card' ? 'brand' : 'neutral';
	}

	get tableVariant() {
		return this.defaultView === 'Table' ? 'brand' : 'neutral';
	}
	get sortBy() {
		return [
			{label: ss_idea_label_PopularIdeas, value: "Popular Ideas"},
			{label: ss_idea_label_RecentIdeas, value: "Recent Ideas"},
			{label: ss_idea_label_TopAllTime, value: "Top All-Time"},
			{label: ss_idea_label_RecentComments, value: "Recent Comments"}
		
		];
	}
	get autoSlds(){
		return inLexMode();
	}
	get buttonGroup(){
		return (inLexMode()) ? 'slds-p-bottom_small' : (this.displayVariant === 'Featured' && !inLexMode()) ? 'slds-p-bottom_medium' : 'slds-m-right_small';
	}
	get variant(){
		return this.displayVariant === 'Featured' ? 'featured' : this.displayVariant === 'Outline' ? 'slds-card' : 'default';
	}
	
	handleDefaultListView(event) {
		if (this.listId === event.id) 
			this.defaultView = event.value === 'Card' ? 'Card' : event.value === 'Table' ? 'Table'  : 'List';
	}
	handleListView() {
		this.defaultView = 'List';
		fireEvent(this.pageRef, 'listviewoption', {id: this.listId});
	}
	
	handleCardView() {
		this.defaultView = 'Card';
		fireEvent(this.pageRef, 'cardviewoption', {id: this.listId});
	}
	handleTableView() {
		this.defaultView = 'Table';
		fireEvent(this.pageRef, 'tableviewoption', {id: this.listId});
	}
}