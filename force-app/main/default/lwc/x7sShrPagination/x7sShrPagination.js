/*
 * Copyright (c) 2021.  7Summits Inc. All rights reserved.
 */

import { LightningElement, api } from 'lwc';

import buttonNext from '@salesforce/label/c.x7sShrButtonNextPage';
import buttonPrevious from '@salesforce/label/c.x7sShrButtonPreviousPage';
import buttonPlaceholder from '@salesforce/label/c.x7sShrButtonPlaceholder';
import buttonMore from '@salesforce/label/c.x7sShrButtonMore';
import labelMore from '@salesforce/label/c.x7sShrMoreLabelItems';
import labelPage from '@salesforce/label/c.x7sShrLabelPage';

export default class X7sShrPagination extends LightningElement {
	@api variant = 'default'; // default (next/previous), paging (1, 2, 3, 4), more, select
	@api range = 2;
	@api buttonVariant = 'neutral';

    // Paging option: 
	@api currentPage = 1;
	@api totalPages = 1;

    // Item Option:
	@api currentItems = 1; // More will only have current item
	@api totalItems = 0;
    @api itemsPerPage = 10;

	baseButtonClass = 'x7s-pagination_button';

    labels = {
		buttonNext,
		buttonPrevious,
		buttonMore,
		buttonPlaceholder,
		labelMore,
		labelPage,
	};

	get buttonClass() {
		return `slds-button ${this.baseButtonClass} slds-button_${this.buttonVariant}`;
	}
	get buttonIconClass() {
		return `slds-button ${this.baseButtonClass} ${this.baseButtonClass}-icon slds-button_${this.buttonVariant}`;
	}
	get placeholderButtonClass() {
		return `slds-button ${this.baseButtonClass} ${this.baseButtonClass}-placeholder`;
	}

    get showPagination() {
		return parseInt(this.totalPages, 10) > 1;
	}

    get showDefaultPagination() {
		return this.variant === 'default' && parseInt(this.totalPages, 10) > 1;
	}
	get showPagingPagination() {
		return this.variant === 'paging' && parseInt(this.totalPages, 10) > 1;
	}
	get showMorePagination() {
		const currentItems = parseInt(this.currentItems, 10);
		const totalItems = parseInt(this.totalItems, 10);
		return this.variant === 'more' && currentItems !== totalItems;
	}

	get showPrevious() {
		const page = parseInt(this.currentPage, 10);
		return page > 1;
	}
	get showNext () {
		const page = parseInt(this.currentPage, 10);
		const total = parseInt(this.totalPages, 10);
		return page < total;
	}
	get showFirst() {
		const page = parseInt(this.currentPage, 10);
		const range = parseInt(this.range, 10);
		// 3, 2 = no 1 | 2 | 3
		// 3, 1 = yes 1 | 2 | 3 
		// 3, 0 = yes 1 | ... | 3 
		//       3  -   2  + 1 = 0
		//       3  -   1  + 1 = 1
		//       3  -   0  + 1 = 2
		return page - range > 1;
	}
	get showFirstPlaceholder() {
		const page = parseInt(this.currentPage, 10);
		const range = parseInt(this.range, 10);
		return page - range > 2;
	}
	get showLast() {
		const page = parseInt(this.currentPage, 10);
		const range = parseInt(this.range, 10);
		const total = parseInt(this.totalPages, 10);
		// 8, 8 = no 7 | 8
		// 8, 7 = yes 7 | 8
		// 8, 6 = yes 6 ... 8
		//       8  -   1    >   8
		//       8  -   1    >   7
		//       8  -   1    >   6
		return total - range > page;
	}
	get showLastPlaceholder() {
		const page = parseInt(this.currentPage, 10);
		const range = parseInt(this.range, 10);
		const total = parseInt(this.totalPages, 10);
		return total - range > page + 1;
	}

	get paginationItems() {
		const total = parseInt(this.totalPages, 10);
		const current = parseInt(this.currentPage, 10);
		const range = parseInt(this.range, 10);
		let items = [];
		if(total && total > 0) {
			for (var i = 1; i <= total; i++) {
				if (current - range <= i && i <= current + range) {
					items.push({
						label: i,
						class: i === current ? `slds-button ${this.baseButtonClass} slds-button_brand` : `slds-button ${this.baseButtonClass} slds-button_${this.buttonVariant}`,
					});
				}
			}
		}
		return items;
	}

    nextHandler(evt) {
        const clickEvent = new CustomEvent('next', {
            detail: parseInt(this.currentPage, 10) + 1
        });
        this.dispatchEvent(clickEvent);
    }
    previousHandler(evt) {
        const clickEvent = new CustomEvent('previous', {
            detail: parseInt(this.currentPage, 10) - 1
        });
        this.dispatchEvent(clickEvent);
    }
    pageHandler(evt) {
        const clickEvent = new CustomEvent('page', {
            detail: parseInt(evt.currentTarget.innerText, 10)
        });
        this.dispatchEvent(clickEvent);
    }
    moreHandler(evt) {
        const clickEvent = new CustomEvent('more', {
            detail: parseInt(this.currentItems, 10)
        });
        this.dispatchEvent(clickEvent);
    }
}