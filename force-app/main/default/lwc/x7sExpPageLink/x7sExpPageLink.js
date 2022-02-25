/**
 * Copyright (c) 2020. 7Summits Inc.
 */

import {api, LightningElement} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class X7SExpPageLink extends NavigationMixin(LightningElement) {

    @api linkLabel;

    page; // private array containing community page API name and section to open on page load

    /**
     * navigate to community page by page API name
     * append section as query string
     */
    handleClick() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                name: this.page[0]
            },
            state: {
                section: this.page[1]
            }
        });
    }

    /**
     * get community page API name
     * set community page API name and section query string array
     * @returns {*}
     */
    @api
    get linkApi() {
        return this.page;
    };

    set linkApi(x) {
        this.page = x.split(',');
    }
}