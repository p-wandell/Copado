/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";
import {fireEvent, inLexMode,registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import labelNameAtoZ from '@salesforce/label/c.x7sFilesListControlNameAtoZLabel';
import labelNameZtoA from '@salesforce/label/c.x7sFilesListControlNameZtoALabel';
import labelTypeAtoZ from '@salesforce/label/c.x7sFilesListControlTypeAtoZLabel';
import labelTypeZtoA from '@salesforce/label/c.x7sFilesListControlTypeZtoALabel';
import labelFileSizeSmallest from '@salesforce/label/c.x7sFilesListControlFileSizeSmallestLabel';
import labelFileSizeLargest from '@salesforce/label/c.x7sFilesListControlFileSizeLargestLabel';
import labelDateNewest from '@salesforce/label/c.x7sFilesListControlDateNewestLabel';
import labelDateOldest from '@salesforce/label/c.x7sFilesListControlDateOldestLabel';
import titleViewCard from '@salesforce/label/c.x7sShrTitleViewCard';
import titleViewList from '@salesforce/label/c.x7sShrTitleViewList';
import altViewCard from '@salesforce/label/c.x7sShrLabelAltViewCard';
import altViewList from '@salesforce/label/c.x7sShrLabelAltViewList';
import titleViewTable from '@salesforce/label/c.x7sFilesListControlTableLabel';
import altViewTable from '@salesforce/label/c.x7sFilesListControlAltTableCard';
import listControlAriaLabel from '@salesforce/label/c.x7sFilesListControlAriaLabel';

export default class X7sFilesListControl extends LightningElement {
    @api listId = 'ID_1';
	@api customClass = '';
	@api showViewSelector = 'true';
	@api showPagination = 'true';
	@api showSort = 'true';
	@api sortVariant = 'Standard';
	@api defaultSort = "Name (A to Z)";
	@api showTable = 'true';
	@api showList = 'true';
	@api showCard = 'true';
	@api displayVariant = 'None'; 
	@api paginationVariant = 'Default'; // Default, Paging, more
	defaultView;

	@wire(CurrentPageReference) pageRef;

	labels={titleViewCard,titleViewList,titleViewTable,altViewCard,altViewList,altViewTable,listControlAriaLabel}

	connectedCallback() {
		registerListener("listdefaultview", this.handleDefaultListView, this);
		registerListener("listsortby", this.handleListSortBy, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
    }

	get sortOptions(){
        return [
            {label : labelNameAtoZ,  value :labelNameAtoZ},
            {label : labelNameZtoA, value :labelNameZtoA},
			{label : labelTypeAtoZ,  value :labelTypeAtoZ},
			{label : labelTypeZtoA, value :labelTypeZtoA},
			{label : labelFileSizeSmallest,  value :labelFileSizeSmallest},
			{label : labelFileSizeLargest, value :labelFileSizeLargest},
			{label : labelDateNewest,  value :labelDateNewest},
			{label : labelDateOldest, value :labelDateOldest},
        ];
    }

	get componentClass() {
		return `x7s-files-list-control ${this.customClass}`;
	}
	
	get variant(){
		return this.displayVariant === 'Featured' ? 'featured' : this.displayVariant === 'Outline' ? 'slds-card' : 'default';
	}

    get hidePagination() {
		return !this.showPagination;
	}

	get hideSort() {
		return !this.showSort;
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

	get getSortVariant() {
		return this.sortVariant === 'Standard' ? 'standard' : 'Label-hidden';
	}

	get hideViewSelector() {
		return !this.showViewSelector;
	}

	get paginationVariantInLower() {
		return this.paginationVariant.toLowerCase();
	}

	handleDefaultListView(event) {
		if (this.listId === event.id && this.showViewSelector) {

			let activeView = event.value;
			let defaultView;

			if(activeView === 'Card' && this.showCard) {
				defaultView = 'Card';
			} else if(activeView === 'Table' && this.showTable) {
				defaultView = 'Table';
			} else if(activeView === 'List' && this.showList) {
				defaultView = 'List';
			}
			
			if(defaultView !== undefined) {
				this.defaultView = defaultView;

			} else if(!this.showList && !this.showTable && !this.showCard) {
				
				//If all view options are set to hidden
				if(activeView === 'Table') {
					this.showTable = true;
					this.defaultView = 'Table'
				} else if(activeView === 'List') {
					this.showList = true;
					this.defaultView = 'List';
				} else {
					this.showCard = true;
					this.defaultView = 'Card';
				}
			} else {
				this.defaultView = this.showCard ? 'Card' : this.showTable ? 'Table' : 'List';
				fireEvent(this.pageRef, 'resetViewOption', {id: this.listId, value: this.defaultView});
			}
        }
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

	handleTotalPages(event) {
        this.totalPages = event.value;
	}

	handleListSortBy(event){
        if(event.id === this.listId){
			let defaultSort = event.value;
			if(defaultSort === "A to Z Name"){this.defaultSort = labelNameAtoZ }
		    else if(defaultSort === "Z to A Name"){this.defaultSort = labelNameZtoA }
		    else if(defaultSort === "A to Z Type"){this.defaultSort = labelTypeAtoZ }
		    else if(defaultSort === "Z to A Type"){this.defaultSort = labelTypeZtoA }
		    else if(defaultSort === "Low To High Size"){this.defaultSort = labelFileSizeSmallest }
		    else if(defaultSort === "High to Low Size"){this.sodefaultSortrtBy = labelFileSizeLargest }
		    else if(defaultSort === "High to Low Date" ){this.defaultSort = labelDateNewest }
		    else if(defaultSort === "Low To High Date" ){this.defaultSort = labelDateOldest }
        }
    }

	get isSldsCard(){
		return inLexMode();
	}

}