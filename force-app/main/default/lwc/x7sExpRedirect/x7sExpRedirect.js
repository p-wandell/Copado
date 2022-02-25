/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class x7sExpRedirect extends NavigationMixin(LightningElement){

    @api Type;
    @api Target;

    connectedCallback() {
        var currentURL = window.location.hostname;
        var isBuilder = (// check if we're in builder before redirecting
            currentURL.indexOf('livepreview') >= 0 ||
            currentURL.indexOf('sitepreview') >= 0 ||
            currentURL.indexOf('--live') >= 0 ||
            currentURL.indexOf('--builder') >= 0
        );
        if(!isBuilder && this.Target) {
            //record page, community page, external site
            if(this.Type === 'community page') {
                console.log('community page');

                // navigate to the community page provided
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        pageName: this.Target
                    }
                });
            } else if(this.Type === 'object list') {
                // navigate to the object list page provided
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: this.Target,
                        actionName: 'list'
                    },
                    state: {
                        filterName: 'Recent'
                    }
                });
            } else if(this.Type === 'record page') {
                // for a record Id, navigate to the record page for the provided Id
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.Target,
                        actionName: 'view'
                    },
                });
            } else if(this.Type === 'external site'){
                // test the provided link to verify that it is an external url then navigate
                const regEx = new RegExp("^(http|https)://", "i");
                if(regEx.test(this.Target)){
                    window.open(this.Target, '_self');
                }
            }
        }
    }
}