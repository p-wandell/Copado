/*
 * Copyright (c) 2020. 7Summits Inc.
 */


import {LightningElement, api} from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import { classSet } from 'c/x7sShrUtils';

export default class X7sExpUtilityNavigation extends LightningElement {

    @api mobileHamburger = false;

    @api userLink1;
    @api userLink1Text;
    @api userLink1IsButton = false;
    @api userLink1OpenInNewPage = false;

    @api userLink2;
    @api userLink2Text;
    @api userLink2IsButton = false;
    @api userLink2OpenInNewPage = false;

    @api userLink3;
    @api userLink3Text;
    @api userLink3IsButton = false;
    @api userLink3OpenInNewPage = false;

    @api userLink4;
    @api userLink4Text;
    @api userLink4IsButton = false;
    @api userLink4OpenInNewPage = false;

    @api userLink5;
    @api userLink5Text;
    @api userLink5IsButton = false;
    @api userLink5OpenInNewPage = false;

    @api userLink6;
    @api userLink6Text;
    @api userLink6IsButton = false;
    @api userLink6OpenInNewPage = false;

    @api userLink7;
    @api userLink7Text;
    @api userLink7IsButton = false;
    @api userLink7OpenInNewPage = false;

    @api userLink8;
    @api userLink8Text;
    @api userLink8IsButton = false;
    @api userLink8OpenInNewPage = false;

    // guest links
    @api guestLink1;
    @api guestLink1Text;
    @api guestLink1IsButton = false;
    @api guestLink1OpenInNewPage = false;

    @api guestLink2;
    @api guestLink2Text;
    @api guestLink2IsButton = false;
    @api guestLink2OpenInNewPage = false;

    @api guestLink3;
    @api guestLink3Text;
    @api guestLink3IsButton = false;
    @api guestLink3OpenInNewPage = false;

    @api guestLink4;
    @api guestLink4Text;
    @api guestLink4IsButton = false;
    @api guestLink4OpenInNewPage = false;

    @api guestLink5;
    @api guestLink5Text;
    @api guestLink5IsButton = false;
    @api guestLink5OpenInNewPage = false;

    @api guestLink6;
    @api guestLink6Text;
    @api guestLink6IsButton = false;
    @api guestLink6OpenInNewPage = false;

    @api guestLink7;
    @api guestLink7Text;
    @api guestLink7IsButton = false;
    @api guestLink7OpenInNewPage = false;

    @api guestLink8;
    @api guestLink8Text;
    @api guestLink8IsButton = false;
    @api guestLink8OpenInNewPage = false;

    @api customClass = '';

    @api backgroundColor = 'var(--lwc-colorBrand);';
    @api inverse = false;
    @api container = 'x-large';
    @api align = 'right';

    isGuestUser = isGuest;

    /**
     * return SLDS alignment class and any additional SLDS or CSS class(es) on <section> element
     * @returns {string}
     */
    get componentClass() {
        return `slds-is-relative ${this.customClass}`;
    }

    get componentStyle() {
        return this.backgroundColor ? `background-color: ${this.backgroundColor}` : '';
    }

    get pageContainerClass() {
        return classSet('slds-grid slds-wrap')
            .add({
                'slds-container_center': this.container !== 'none',
                'slds-container_small': this.container === 'small',
                'slds-container_medium': this.container === 'medium',
                'slds-container_large': this.container === 'large',
                'slds-container_x-large': this.container === 'x-large',
                'cCenterPanel': this.container === 'default',
                'slds-grid_align-end': this.align === 'right',
                'slds-grid_align-center': this.align === 'center'
            })
            .toString();
    }
}