/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track, wire} from "lwc";
import {CurrentPageReference} from "lightning/navigation";

import {classSet} from "c/x7sShrUtils";
import {fireEvent} from "c/x7sShrUtils";

export default class X7sShrObjectBanner extends LightningElement {
	@api listId = '';
	@api customClass = "";
	@api hideIcon = false;
	@api hideSearch = false;
	@api hideTitle = false;
	@api iconName = "standard:groups";
	@api searchPlaceHolder = "Search";
	@api searchString = "";
	@api title = "Banner Title Text";
	@api variant = "default"; // default, slds-card, featured, transparent
	@api debounceTimer = 300; // milliseconds
	debounceTimeout;
	
	@track hasFilters = true;
	
	@wire(CurrentPageReference) pageRef;
	
	renderedCallback() {
		this.checkHasFilters();
	}
	
	handleSlotChange(event) {
		this.checkHasFilters();
	}
	
	checkHasFilters() {
		const slot = this.template.querySelector("slot[name='filters']");
		this.hasFilters = slot.assignedElements().length !== 0;
	}

	handleKeyChange(event) {
		const val = event.target.value;
		clearTimeout(this.debounceTimeout);
		this.debounceTimeout = setTimeout(() => {
			fireEvent(this.pageRef, "selected", {
				id: this.listId,
				value: val,
			});
		}, this.debounceTimer);
	}
	
	get wrapperClass() {
		return classSet(`object-banner-wrapper ${this.customClass}`)
			.add({
				"object-banner--has-slot": this.hasFilters,
				"x7s-component_slds-card slds-card": this.variant === "slds-card",
				"x7s-component_default": this.variant === "default",
				"x7s-component_featured": this.variant === "featured",
				"x7s-component_transparent": this.variant === "transparent",
			})
			.toString();
	}
}