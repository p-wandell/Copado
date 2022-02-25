/*
 * Copyright (c) 2021.  7Summits Inc. All rights reserved.
 */

import { LightningElement, api, track } from 'lwc';
import { classSet } from 'c/x7sShrUtils';

export default class X7sShrList extends LightningElement {
    @api layout        = 'grid'; // grid, list, lightning
    @api customClass   = '';

    // applies when using grid or list
    // TODO: add a config that stretches this out when you have fewer items then fit in a row.
    @api cardGap       = "1rem";
    @api cardWidth     = "200px";

    // Applies when using lightning
    @api horizontalAlign = 'spread';
    @api multipleRows = false;
    @api pullToBoundary = '';
    @api verticalAlign = 'start';

    get listClass() {
        return classSet(`x7s-list ${this.customClass}`)
        .add({
            'x7s-list_grid': this.layout.toLowerCase() === 'grid',
            'x7s-list_list': this.layout.toLowerCase() === 'list',
            'x7s-list_lightning': this.layout.toLowerCase() === 'lightning',
        })
        .toString();
    }

    get listStyle() {
        let style = '';
        if (this.cardWidth && this.cardWidth !== '' && this.layout.toLowerCase() === 'grid') {
            style += `grid-template-columns: repeat(auto-fill, minmax(${this.cardWidth}, 1fr));`;
        }
        if (this.cardGap && this.cardGap !== '') {
            style += `grid-gap: ${this.cardGap};`;
        }
        return style;
    }

    get isLightning() {
        return this.layout.toLowerCase() === 'lightning';
    }
}