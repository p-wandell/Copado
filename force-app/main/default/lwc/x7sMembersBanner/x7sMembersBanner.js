/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import { LightningElement, api, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";

import {
  registerListener,
  unregisterAllListeners,
  fireEvent
} from "c/x7sShrUtils";

export default class X7sMembersBanner extends LightningElement {
	
  @api listId = "ID_1";
  @api iconName = "standard:groups";
  @api showBottomBorder = "true";
  @api memberTitle = "";
  @api showNumberOfMembers = "true";
  @api numberOfMembers="0";
  @api showSort;
  @api customClass = "";
  @api showTheme = "false";
  @api searchPlaceHolder = "Search";
  @api displaySearch = "true";

  @track totalMember;
  @track searchString;

  @wire(CurrentPageReference) pageRef;

  connectedCallback() {
    registerListener("totalmembers", this.updateTotal, this);
    registerListener("selected", this.handleSearch, this);
  }

  disconnectedCallback() {
    unregisterAllListeners(this);
  }
  handleSearch(event) {
    if (event.value !== undefined && this.listId === event.id) {
      fireEvent(this.pageRef, "searchstring", {
        id: this.listId,
        value: event.value
      });
    }
  }
  updateTotal(event) {
    if (event.value !== undefined && this.listId === event.id) {
      this.numberOfMembers = event.value;
    }
  }
  get hideSearch() {
		return !this.displaySearch;
	}
	
	get hideTitle() {
		return !this.memberTitle && !this.showNumberOfMembers;
	}
	
	get memberBannerTitle () {
		return this.showNumberOfMembers ? this.numberOfMembers + ' ' + this.memberTitle : this.memberTitle;
	}
	
	get hideIcon() {
		return (this.iconName === '' || this.iconName === undefined);
	}
	
	get bottomBorder() {
		return this.showBottomBorder ? 'slds-p-bottom_small slds-border--bottom' : '';
	}
	
	get componentClass() {
		return `x7s-members-banner ${this.customClass}`;
	}
}