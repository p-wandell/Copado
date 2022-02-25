/**
 * Copyright (c) 2020. 7Summits Inc.
 */

import {api, LightningElement, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";
import * as Util from 'c/x7sExpFaqUtils'

export default class X7SExpFaq extends LightningElement {

    @api question = '';
    @api answer = '';
    @api selectedSectionClass = 'slds-card';
    @api customClass = '';
    @api useAccordion = false;

    section; // track active section from currentPageReference.state

    /**
     * get active section from 'section' URL query string
     * set the open section
     * @param currentPageReference
     */
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.section = Util.kebabCase(currentPageReference.state.section);
    }

    /**
     * scroll to active section after DOM has rendered
     */
    renderedCallback() {
        const section = `section.${this.section}`;
        const element = this.template.querySelector(section);

        if(element) {
            const offset = this.useAccordion ? element.offsetHeight : -10;
            setTimeout(function(){
                console.log(element.offsetHeight);
                Util.scrollTo(element, offset);
            }, 100);
        }
    }

    get computedSectionClass() {
        const selectedSectionClass = Util.kebabCase(this.question) === this.section ? this.selectedSectionClass : '';
        return `${Util.kebabCase(this.question)} ${selectedSectionClass} ${this.customClass}`;
    }

    get computedSectionName() {
        return Util.kebabCase(this.question);
    }

}