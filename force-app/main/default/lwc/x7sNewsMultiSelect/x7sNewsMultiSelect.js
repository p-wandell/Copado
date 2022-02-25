/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import {LightningElement, api} from 'lwc';

import {NavigationMixin} from 'lightning/navigation';

export default class X7sNewsMultiSelect extends NavigationMixin(LightningElement) {
	
	@api items = [];
	@api selectedItemIds = [];
	@api readOnly = false;
	@api selectedItems = [];
	@api availableItems = [];
	@api isOptionsVisible = false;
	@api labelName;
	@api itemlabel;
	@api ariaSelectedItemsLabel = 'Selected Items'; // Default value - typically populated by parent component, from custom label
	
	@api
	get selectionList() {
		return this.selectedItemIds;
	}
	
	set selectionList(value) {
		this.selectedItemIds = value;
		this.getRefreshSelectionData();
	}
	
	connectedCallback() {
		this.getRefreshSelectionData();
	}
	
	@api
	getRefreshSelectionData() {
		let _items = JSON.parse(JSON.stringify(this.items));
		_items.sort(function (a, b) {
			var nameA = a.name.toUpperCase(); // ignore upper and lowercase
			var nameB = b.name.toUpperCase(); // ignore upper and lowercase
			if (nameA < nameB) {
				return -1;
			}
			if (nameA > nameB) {
				return 1;
			}
			
			// names must be equal
			return 0;
		});
		let _selectedItemIds = JSON.parse(JSON.stringify(this.selectedItemIds));
		let _selectedItems = [];
		let _availableItems = [];
		//console.log(_items);
		//console.log(_selectedItemIds);
		for (var i = 0; i < _items.length; i++) {
			if (_selectedItemIds.length > 0 && _selectedItemIds.indexOf(_items[i].id) > -1) {
				_selectedItems.push(_items[i]);
			} else {
				_availableItems.push(_items[i]);
			}
		}
		this.availableItems = _availableItems;
		this.selectedItems = _selectedItems;
	}
	
	doSelection(event) {
		//console.log(this.selectedItemIds);
		this.isOptionsVisible = false;
		let _selectedItemIds = JSON.parse(JSON.stringify(this.selectedItemIds));
		_selectedItemIds.push(event.target.value);
		this.selectedItemIds = _selectedItemIds;
		
		this.getRefreshSelectionData();
		this.handleItemSelection();
		
	}
	
	removeSelection(event) {
		let _selectedItemIds = JSON.parse(JSON.stringify(this.selectedItemIds));
		_selectedItemIds.splice(_selectedItemIds.indexOf(event.target.name), 1);
		this.selectedItemIds = _selectedItemIds;
		this.getRefreshSelectionData();
		this.handleItemSelection();
	}
	
	showOptions() {
		this.isOptionsVisible = true;
	}
	
	hideOptions() {
		this.isOptionsVisible = false;
	}
	
	gotoItemUrl(event) {
		let recId = event.currentTarget.dataset.id;
		//console.log(recId);
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recId,
				actionName: 'view',
			},
		});
	}
	
	handleItemSelection() {
		const event = new CustomEvent('itemchangeevent', {
			// detail contains only primitives
			detail: this.selectedItemIds
		});
		// Fire the event from c-tile
		this.dispatchEvent(event);
	}
	
	
}