/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {fireEvent} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";

export default class X7sIdeasCustomLookUpDropdown extends LightningElement {
	
	@api oRecord;
	@api selectedRecord;
	@api objectType;
	@wire(CurrentPageReference) pageRef;
	
	get objTypeClass() {
		return (this.objectType == 'User' ? '' : 'slds-hide');
	}
	
	selectRecord() {
		// get the selected record from list
		let selectedEvent = new CustomEvent('selectrecord', {detail: true});
		this.dispatchEvent(selectedEvent);
		
		let getSelectRecord = this.oRecord;
		fireEvent(this.pageRef, 'selectrecval', {value: getSelectRecord});
		fireEvent(this.pageRef, 'customlookselectedrec', {value: getSelectRecord});
	}
}