/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

export default class X7SAdventureProgressRing extends LightningElement {

    @api size = 'medium';
    @api value = 0;

    get hasValue() {
        return this.value !== null && this.value !== undefined;
    }

    get computedClass() {

        if (this.value === 100) {
            return [
                'slds-progress-ring',
                'slds-progress-ring_complete',
                'ringHover',
                'x7s-adventure-progress-ring',
                `x7s-adventure-progress-ring--${this.size}`
            ].join(' ');
        } else {
            return [
                'slds-progress-ring',
                'ringHover',
                'x7s-adventure-progress-ring',
                `x7s-adventure-progress-ring--${this.size}`
            ].join(' ');
        }
    }

    get showValue() {
        return this.size === 'medium' || 'small';
    }

    get percent() {
        return this.value / 100;
    }

    get valueInt() {
        return parseInt(this.value);
    }

    get isLong() {
        return this.value > 50 ? 1 : 0;
    }

    get arcX() {
        return Math.cos(2 * Math.PI * this.percent);
    }

    get arcY() {
        return -Math.sin(2 * Math.PI * this.percent)
    }

    get svgD() {
        return `M 1 0 A 1 1 0 ${this.isLong} 0 ${this.arcX} ${this.arcY} L 0 0`;
    }

    get ringSize() {
        let flag = true
        if (this.size === 'small') {
            flag = false;
        }
        return flag;
    }

    get isCompleted() {
        let flag = false;
        if (this.value === 100) {
            flag = true;
        }
        return flag;
    }

}