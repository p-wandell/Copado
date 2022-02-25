/*
 * Copyright (c) 2020. 7Summits Inc.
 */


import {LightningElement, api} from 'lwc';

export default class X7sExpSpacer extends LightningElement {

    @api size = 'medium'; // xxx-small,xx-small,x-small,small,medium,large,x-large,xx-large
    @api exactSize;
    @api showBorder = false;
    @api removeSpacing = false;

    /**
     * css classes for container
     * @returns {string} slds padding and custom "remove spacing" class
     */
    get componentClass() {
        const noAdditionalSpacingClass = this.removeSpacing ? ` x7s-spacer_no-additional-spacing` : ``;
        return this.showBorder ? `slds-p-vertical_${this.size}${noAdditionalSpacingClass}` : `slds-p-top_${this.size}${noAdditionalSpacingClass}`;
    }

    /**
     * inline style for exact sizes
     * @returns {string} padding with exact size value
     */
    get exactSizeStyle() {
        return this.exactSize ? `padding-top: ${this.exactSize};` + (this.showBorder ? `padding-bottom: ${this.exactSize};` : ``) : ``;
    }

}