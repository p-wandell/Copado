/*
 * Copyright (c) 2020. 7Summits Inc.
 */


import {LightningElement, api, track} from 'lwc';
import { classSet } from 'c/x7sShrUtils';

export default class X7sExpNavigationList extends LightningElement {

    @api mobileHamburger = false;
    @api inverse = false;

    @api link1;
    @api link1Text;
    @api link1IsButton = false;
    @api link1OpenInNewPage = false;

    @api link2;
    @api link2Text;
    @api link2IsButton = false;
    @api link2OpenInNewPage = false;

    @api link3;
    @api link3Text;
    @api link3IsButton = false;
    @api link3OpenInNewPage = false;

    @api link4;
    @api link4Text;
    @api link4IsButton = false;
    @api link4OpenInNewPage = false;

    @api link5;
    @api link5Text;
    @api link5IsButton = false;
    @api link5OpenInNewPage = false;

    @api link6;
    @api link6Text;
    @api link6IsButton = false;
    @api link6OpenInNewPage = false;

    @api link7;
    @api link7Text;
    @api link7IsButton = false;
    @api link7OpenInNewPage = false;

    @api link8;
    @api link8Text;
    @api link8IsButton = false;
    @api link8OpenInNewPage = false;

    @track showMobileMenu = false;


    handleMobileMenuClick() {
        this.showMobileMenu = !this.showMobileMenu;
    }

    get mobileMenuIconVariant() {
        return this.inverse ? `border-inverse` : ``;
    }

    get mobileMenuIcon() {
        return this.showMobileMenu ? `utility:close` : `utility:rows`;
    }

    get navContainerClass() {
        return this.showMobileMenu ? `slds-hide_medium slds-show` : `slds-hide_medium slds-hide`;
    }

    get horizontalMenuContainerClass() {
        return classSet('slds-list_horizontal slds-has-inline-block-links_space slds-grid_vertical-align-center')
            .add({
                'slds-show_medium': this.mobileHamburger,
                'slds-theme_inverse': this.inverse
            })
            .toString();
        }

}