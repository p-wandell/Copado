/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';
import { classSet } from 'c/x7sShrUtils';

export default class x7sShrMeta extends LightningElement {
    @api customClass = '';
    @api count;
    @api hideCount;
    @api hideLabel;
    @api icon;
    @api label;
    @api size = 'xx-small';
    @api useLink = false;
    @api linkId;
    @api variant = 'default'; // default, allcaps

    get componentClass() {
        return classSet(`x7s-shr-meta ${this.customClass} `)
        .add({
            'x7s-meta_allcaps': this.variant === 'allcaps'
        })
        .toString();
    }

    handleClick() {
        const clickEvent = new CustomEvent('click', {
            detail: this.linkId,
        });
        this.dispatchEvent(clickEvent);
    }
}