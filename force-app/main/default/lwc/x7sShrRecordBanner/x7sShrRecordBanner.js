import { LightningElement, api, track } from 'lwc';

import { classSet } from 'c/x7sShrUtils';

export default class X7sShrRecordBanner extends LightningElement {
    @api title = "Banner Title Text";
    @api subtitle = "";
    @api description = "";
    @api titleSize = "large"; // Options include: small, medium, large, x-large;
    @api subtitleSize = "medium"; // Options include: small, medium, large, x-large;
    @api titleSlotSize = "80px;";
    @api topics;


    @track hasActionsSlot = true;
    @track hasMetaSlot = true;
    @track hasTitleSlot = true;
    @track showTopics = false;

    renderedCallback() {
        this.checkHasMetaSlot();
        this.checkHasTitleSlot();
        this.checkHasActionsSlot();
	}

	handleSlotChange(event) {
        this.checkHasMetaSlot();
        this.checkHasTitleSlot();
        this.checkHasActionsSlot();
    }

    checkHasTitleSlot() {
		const slot = this.template.querySelector("slot[name='title']");
		this.hasTitleSlot = slot.assignedElements().length !== 0;
    }
    checkHasMetaSlot() {
		const slot = this.template.querySelector("slot[name='meta']");
		this.hasMetaSlot = slot.assignedElements().length !== 0;
    }
    checkHasActionsSlot() {
		const slot = this.template.querySelector("slot[name='actions']");
		this.hasActionsSlot = slot.assignedElements().length !== 0;
    }

    get containerClass() {
        return classSet(`record-banner_container`)
        .add({
            'record-banner_has-title-slot': this.hasTitleSlot,
            'record-banner_has-actions-slot': this.hasActionsSlot,
        })
        .toString();
    }

    get metaClass() {
        return classSet(`record-banner_meta`)
        .add({
            'record-banner_has-meta-slot': this.hasMetaSlot,
        })
        .toString();
    }

    get titleClass() {
        return classSet(`record-banner_title`)
        .add({
            'slds-text-heading_small': this.titleSize === 'small',
            'slds-text-heading_medium': this.titleSize === 'medium',
            'slds-text-heading_large': this.titleSize === 'large',
            'slds-text-heading_x-large': this.titleSize === 'x-large',
            'slds-m-bottom_xx-small': this.subtitle,
        })
        .toString();
    }

    get subtitleClass() {
        return classSet(`record-banner_subtitle`)
          .add({
              'slds-text-heading_small': this.subtitleSize === 'small',
              'slds-text-heading_medium': this.subtitleSize === 'medium',
              'slds-text-heading_large': this.subtitleSize === 'large',
              'slds-text-heading_x-large': this.subtitleSize === 'x-large',
              'slds-m-bottom_x-small': this.description,
          })
          .toString();
    }

    get titleSlotStyle() {
        let style = `flex-basis: ${this.titleSlotSize};height: ${this.titleSlotSize};`;
        return style;
    }

}