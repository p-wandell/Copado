/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

export default class X7sExpHtmlHeadings extends LightningElement {

    @api text = '';
    @api tag = 'H1 - Page Heading';
    @api size = 'none'; // large, medium, small
    @api align = 'left';
    @api customClass = '';

    // - Value getters --------------------------------------------------------

    /**
     * Return HTML Heading tag with size class (if 'size' is not 'none')
     * @returns {string}
     */
    get htmlHeading() {
        const tag = (this.tag).substring(0,2).toLowerCase();
        const size = this.size !== 'none' ? ` class="slds-text-heading_${this.size}"` : '';
        return `<${tag}${size}>${this.text}</${tag}>`;
    }

    /**
     * Return SLDS alignment class and any additional SLDS or CSS class(es) on <section> element
     * @returns {string}
     */
    get componentClass() {
        return `html-heading-container slds-text-align_${this.align} ${this.customClass}`.trim();
    }

    // - Callbacks and Event handlers -----------------------------------------

    /**
     * Render the H1,H2,H3,H4 or H5 directly. Using a component like 'lightning-formatted-rich-text'
     * will favor its sizing style rules over any slds-text-heading_<size> class on the header element.
     */
    renderedCallback() {
        this.template.querySelector('.html-heading-container').innerHTML = this.htmlHeading;
    }
}