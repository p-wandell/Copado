/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {api, LightningElement} from 'lwc';
import { classSet } from 'c/x7sShrUtils';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';

export default class X7sExpIFrame extends LightningElement {

    @api title;
    @api titleAlign = 'left';
    @api contentAlign = 'center';
    @api height = '800';
    @api width = '100%';
    @api url = '';
    @api showLoadingSpinner = false;
    @api customClass = '';
    label = {labelAriaWrapper};
    loading = false;

    /**
     * show loading spinner while iframe content loads
     */
    connectedCallback() {
        this.loading = true;
    }

    /**
     * create iframe programmatically and add to DOM
     */
    renderedCallback() {

        // make sure we have a src url before creating the iframe
        if(this.url) {
            const spinnerContainer = this.template.querySelector('.slds-spinner_container');
            const containerElem = this.template.querySelector('.iframe-container');
            const iframe = document.createElement('iframe');
            const showLoadingSpinner = this.showLoadingSpinner;

            // onload() before setting 'src'
            iframe.onload = function () {
                if(showLoadingSpinner) {
                    spinnerContainer.classList.add("slds-hide"); // hide spinner
                }
                console.log('iframe is loaded');
            };
            iframe.src = this.url; // iframe src; add this URL to CSP
            iframe.id = `iframe-${this.randomId()}`;
            iframe.width = this.width ? this.testSize(this.width) : '100%';
            this.height ? iframe.height = this.testSize(this.height) : '';
            iframe.title = `exp iframe`;
            iframe.setAttribute('frameborder', '0');

            containerElem.appendChild(iframe); // add iframe to DOM
        }
    }

    /**
     * generate a random number from 1-1000 for the iframe ID
     * @returns {number}
     */
    randomId() {
        return Math.floor(Math.random() * 1000);
    }

    /**
     * test a size value to make sure it begins with a number and ends with '%' or 'px'
     * if the regex test fails, return any number contained in the string without a unit
     * @param size
     * @returns {*}
     */
    testSize(size) {
        // return size ? parseInt(size.replace(/\D/g,'')) : '';
        const regex = /^\d*\.?\d+(?:px|%)?$/i;
        return regex.test(size) ? size : parseInt(size.replace(/\D/g,''));
    }

    /**
     * returns the iframe container class with grid and grid alignment
     * @returns {string}
     */
    get iframeContainerClass() {
        return classSet('iframe-container slds-grid')
            .add({
                'slds-grid_align-start': this.contentAlign === 'left',
                'slds-grid_align-center': this.contentAlign === 'center',
                'slds-grid_align-end': this.contentAlign === 'right',
            })
            .toString();
    }

}