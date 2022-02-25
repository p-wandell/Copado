/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { classSet, inLex } from 'c/x7sShrUtils';
import { CurrentPageReference } from "lightning/navigation";

export default class X7sShrComponentWrapper extends LightningElement {
    @api customClass = '';
    @api variant = 'default'; // default, slds-card, featured
    @api title = '';
    @api titleAlign = 'left'; // left, center, right
    @api description = '';
    @api iconName = '';
    @api iconSize = 'medium'; // xx-small, x-small, small, medium, or large

    @api hideHeader = false;
    @api hideFooter = false;
    @api showBranding = false;
    @api autoSldsCard = false;
    @api shadedHeader = false;      // Adds a shaded header to the top of the component
    @api removeBodyPadding = false;

    @track hasFooter = true;
    @track inLightningExperience = false;
    @track forceSldsCard = false;

    data = null;

    @wire(CurrentPageReference)
    wirePageRef(data){
        if(data){
            this.data = data;
        }
    }

    connectedCallback(){
        if (this.data) {
            this.inLightningExperience = inLex(this.data);
            // forces an SLDS card class to be applied if we've turned on auto sensing and we're in lightning experience
            this.forceSldsCard = this.autoSldsCard && this.inLightningExperience;
        }
    }

    renderedCallback() {
        this.checkHasFooter();
    }

    handleFooterSlotChange() {
        this.checkHasFooter();
    }

    checkHasFooter() {
        const slot = this.template.querySelector("slot[name='footer']");
        this.hasFooter = slot && slot.assignedElements().length !== 0;
    }

    get titleVerticalAlign() {
        return (this.description && this.iconName && this.titleAlign !== 'center') ? 'start' : false;
    }

    get componentClass() {
        return classSet(`x7s-component ${this.customClass}`)
            .add({
                'x7s-component_slds-card slds-card': this.variant === 'slds-card' || this.forceSldsCard,
                'x7s-component_default': this.variant === 'default' && !this.forceSldsCard,
                'x7s-component_featured': this.variant === 'featured' && !this.forceSldsCard,
                'x7s-component_has-icon': this.iconName !== '',
                'slds-grid_align-center slds-text-align_center': this.titleAlign === 'center',
                'slds-text-align_right': this.titleAlign === 'right'
            })
            .toString();
    }

    get showHeader() {
        return !!this.title || !!this.description || !!this.iconName;
    }

    get headerClass() {
        return classSet('x7s-component__header')
            .add({
                'slds-card__header': this.variant === 'slds-card' || this.forceSldsCard,
                'slds-grid_align-start slds-text-align_left': this.titleAlign === 'left',
                'slds-grid_align-center slds-text-align_center': this.titleAlign === 'center',
                'slds-text-align_right': this.titleAlign === 'right',
                'x7s-component_header--shaded': this.shadedHeader
            })
            .toString();
    }

    get bodyClass() {
        return classSet('x7s-component__body')
            .add({
                'slds-card__body slds-card__body_inner': this.variant === 'slds-card' || this.forceSldsCard,
                'x7s-component__body-no-padding': this.removeBodyPadding
            })
            .toString();
    }

    get footerClass() {
        return classSet('x7s-component__footer')
            .add({
                'slds-card__footer': this.variant === 'slds-card' || this.forceSldsCard,
                'x7s-component__featured-footer': this.variant === 'featured' && !this.forceSldsCard,
                'slds-hide': !this.hasFooter && !this.showBranding
            })
            .toString();
    }
}