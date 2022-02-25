/*
 * Copyright (c) 2021.  7Summits Inc. All rights reserved.
 */
import {LightningElement, api, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {classSet, registerListener, unregisterAllListeners, fireEvent} from 'c/x7sShrUtils';

import labelSortBy from '@salesforce/label/c.x7sShrLabelSortBy';
import altViewCard from '@salesforce/label/c.x7sShrLabelAltViewCard';
import altViewList from '@salesforce/label/c.x7sShrLabelAltViewList';
import titleViewCard from '@salesforce/label/c.x7sShrTitleViewCard';
import titleViewList from '@salesforce/label/c.x7sShrTitleViewList';

export default class X7sShrListControl extends LightningElement {
	// Wrapper Configuration
    @api autoSldsCard = false;
	@api customClass;
    @api variant = 'default'; // default, slds-card, featured

	@api listId = 'ID_1';
	@api buttonVariant = 'neutral'; // base, neutral, brand, brand-outline, destructive, destructive-text, inverse, and success.
	
	// View Configuration
	@api hideViewSelector = false;
	@track activeView = 'tile';
	
	// Sort Configuration
	@api hideSort = false;
	@api sortVariant = 'standard'; // standard, label-hidden, label-inline, label-stacked
	@api sortOptions;
	@api defaultSort;
	
	// Pagination Configuration
	@api paginationVariant = 'default'; // default, paging, more
	@api paginationRange = 2;
	@api hidePagination = false;
	@api pageNumber = 1;
	@api totalPages;
	@api hasMoreSet;
	@api moreCount = 0;
	@api moreTotal = 0;

	// DEPRECATED April 2021:
	@api showMore = false; // Use paginationVariant="more" instead.
	@api hasPreviousSet = false; // Use totalPages & pageNumber instead.
	@api hasNextSet = false; // Use totalPages & pageNumber instead.
	
	labels = {
		altViewCard,
		altViewList,
		titleViewCard,
		titleViewList,
		labelSortBy,
	};
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		registerListener("listdefaultview", this.handleDefaultListView, this);
		registerListener("listhasnext", this.nextHandle, this);
		registerListener("listhasprevious", this.previousHandle, this);
		registerListener("listpagenumber", this.pageHandle, this);
		registerListener("listtotalpages", this.totalpageHandle, this);
		registerListener('listhasmore', this.moreHandle, this);
		registerListener('listmorecount', this.moreCountHandle, this);
		registerListener('listmoretotal', this.moreTotalHandle, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get componentClass() {
		return `x7s-list-control ${this.customClass}`;
	}
	
	get showMorePagination() {
		return this.hasMoreSet && this.showMore;
	}
	
	get showSort() {
		return !this.hideSort && this.sortOptions && this.sortOptions.length > 0;
	}
	get isInlineVariant() {
		return this.sortVariant === 'label-inline';
	}
	get calculatedSortVariant() {
		// 'label-stacked' adds unnecessary CSS and causes display issues in this layout, use "standard" instead.
		if(this.sortVariant === 'label-stacked') {
			return ('standard');
		}
		return this.sortVariant;
	}

	get listVariant() {
		return this.activeView.toLowerCase() === 'list' ? 'brand' : 'neutral';
	}
	get tileVariant() {
		// some old versions of product used to use 'card' instead of 'tile'. Keeping the check for 'card' for backwards compatability
		return this.activeView.toLowerCase() === 'tile' || this.activeView.toLowerCase() === 'card' ? 'brand' : 'neutral';
	}

	get showPagination() {
		// We show pagination if the user hasn't specifically selected to hide it, or they want to use the old `showMore` method.
		// In other words, explicity setting `this.showMore` overrides `this.hidePagination`.
		return !this.hidePagination || this.showMore;
	}

	get pagingVariant() {
		if (this.showMore) {
			return 'more';
		}
		return this.paginationVariant;
	}

	handleDefaultListView(event) {
		if (this.listId === event.id) {
			// TODO: Rewrite this in a more consistent fashion, that can be used for more than just card/tile & List.
			// Some old versions of product used 'card' or 'vertical' instead of 'tile'. Keeping the check for those for backwards compatability
			if (event.value) {
				const val = event.value.toLowerCase();
				if ( val === 'vertical' || val === 'card' || val === 'tile' ) {
					this.activeView = 'tile';
				} else {
					this.activeView = 'list';
				}
			}
		}
	}
	
	handleListView() {
		this.activeView = 'list';
		fireEvent(this.pageRef, 'listviewoption', {id: this.listId});
	}
	
	handleCardView() {
		this.activeView = 'tile';
		fireEvent(this.pageRef, 'cardviewoption', {id: this.listId});
	}
	
	handleSortBy(event) {
		fireEvent(this.pageRef, 'sortbyevent', {id: this.listId, value: event.target.value});
	}
	
	nextHandle(evt) {
		if (this.listId === evt.id) {
			this.hasNextSet = evt.value;
		}
	}
	
	previousHandle(evt) {
		if (this.listId === evt.id) {
			this.hasPreviousSet = evt.value;
		}
	}
	
	moreHandle(evt) {
		if (this.listId === evt.id) {
			this.hasMoreSet = evt.value;
		}
	}

	pageHandler(evt) {
		fireEvent(this.pageRef, 'page', {
			id: this.listId,
			detail: evt.detail
		});
	}

	previousHandler(evt) {
		fireEvent(this.pageRef, 'pageprevious', {
			id: this.listId,
			detail: evt.detail
		});
	}
	
	nextHandler(evt) {
		fireEvent(this.pageRef, 'pagenext', {
			id: this.listId,
			detail: evt.detail
		});
	}
	
	moreHandler() {
		fireEvent(this.pageRef, 'pagemore', {id: this.listId});
	}
	
	pageHandle(evt) {
		if (this.listId === evt.id) {
			this.pageNumber = evt.value;
		}
	}
	
	totalpageHandle(evt) {
		if (this.listId === evt.id) {
			this.totalPages = evt.value;
		}
	}
	
	moreCountHandle(evt) {
		if (this.listId === evt.id) {
			this.moreCount = evt.value;
		}
	}
	
	moreTotalHandle(evt) {
		if (this.listId === evt.id) {
			this.moreTotal = evt.value;
		}
	}
}