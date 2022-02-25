/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import { classSet } from 'c/x7sShrUtils';

export default class X7sExpNavigationLink extends LightningElement {

    @api link;
    @api text;
    @api isButton = false;
    @api inverse;
    @api openInNewPage;


    get buttonComponentClass() {
        return classSet('')
            .add({
                'slds-button': this.isButton,
                'slds-button_brand': this.isButton,
                'slds-button_inverse': this.isButton && this.inverse
            })
            .toString();
    }

    get target() {
        return this.openInNewPage ? '_target' : '';
    }


}