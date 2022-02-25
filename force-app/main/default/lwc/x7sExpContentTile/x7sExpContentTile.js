/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class X7sExpContentTile extends NavigationMixin(LightningElement) {

    @api customClass;
    @api headline;
    @api subHeadline;
    @api align;
    @api paragraph;
    @api darkText;

    @api buttonUrl;
    @api buttonText;
    @api buttonClass;

    @api buttonUrl2;
    @api buttonText2;
    @api buttonClass2;

    @api headlineTag = 'h1';
    @api headlineSize = 'large';
    @api subHeadlineTag = 'h2';
    @api subHeadlineSize = 'medium';


    /**
     * get the value of the CTA link; if it contains http or https, open link in new window
     * if not, send link to navigateToCommunityPage()
     * @param event
     */
    handleClick(event) {
        const link = event.target.value;
        const reg = new RegExp("^(http|https)://", "i");
        const match = reg.test(link);

        if (match){
            window.open(link, '_blank');
        } else {
            this.navigateToCommunityPage(link);
        }
    }

    /**
     * navigate to community page
     * @param page
     */
    navigateToCommunityPage(page) {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: page
            },
        });
    }

    /**
     * @returns {string} paragraph alignment
     */
    get paragraphClass() {
        return `slds-text-align_${this.align}`;
    }

    /**
     * @returns {string} button variant
     */
    get buttonVariant() {
        return this.darkText ? 'brand' : 'inverse';
    }

    /**
     * Returns a boolean to indicate whether button 1 should be displayed or not
     * @returns {Boolean}
     */
    get displayButton1(){
        return this.buttonText && this.buttonUrl;
    }

    /**
     * Returns a boolean to indicate whether button 2 should be displayed or not
     * @returns {Boolean}
     */
    get displayButton2(){
        return this.buttonText2 && this.buttonUrl2;
    }

    /**
     * Returns a boolean to indicate whether either button should be displayed or not
     * @returns {Boolean}
     */
    get displayButtons() {
        return this.displayButton1 || this.displayButton2;
    }

    get buttonWrapperClass() {
        return `x7s-banner__buttons slds-text-align_${this.align}`;
        center
    }
}