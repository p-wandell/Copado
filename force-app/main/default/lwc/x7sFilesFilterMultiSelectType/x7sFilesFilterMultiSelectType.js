/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import { LightningElement,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class X7sFilesFilterMultiSelectType extends NavigationMixin(LightningElement) {

    @api items=[];
    @api fileData;
    @api selectedItemIds=[];
    @api readOnly=false;
    @api selectedItems=[];
    @api availableItems=[];
    @api isOptionsVisible=false;
    @api labelName='';
    @api itemlabel='';

    connectedCallback() {
       this.getRefreshSelectionData();
    }

    @api
	handleClearAllTopics() {
		this.selectedItemIds = [];
		this.getRefreshSelectionData();
	}

    getRefreshSelectionData(){
        let _items= JSON.parse(JSON.stringify(this.items));
        let _selectedItemIds = JSON.parse(JSON.stringify(this.selectedItemIds));
        let _selectedItems = [];
        let _availableItems = [];
		for(var i=0; i < _items.length; i++){
	        if(_selectedItemIds.length > 0 && _selectedItemIds.indexOf(_items[i].id) > -1){
	            _selectedItems.push(_items[i]);
	        }else{
	        	_availableItems.push(_items[i]);
	        }
        }
        this.availableItems=_availableItems;
        this.selectedItems=_selectedItems;
    }

    doSelection(event) {
        this.isOptionsVisible=false;
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
		this.isOptionsVisible=true;
	}

	hideOptions() {
		this.isOptionsVisible=false;
	}

    get isAvailableItems (){
       return this.availableItems.length > 0 ? true : false;
    }

    defaultHandler(event){
        event => event.preventDefault();
    }

	gotoItemUrl(event){
        let recId=event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                actionName: 'view',
            },
        });
    }
    
    handleItemSelection() {
        const event = new CustomEvent('typechangeevent', {
            // detail contains only primitives
            detail: this.selectedItemIds
        });
        // Fire the event from c-tile
        this.dispatchEvent(event); 
    }

}