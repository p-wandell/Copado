/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class X7sExpFeaturedUserTile extends NavigationMixin(LightningElement) {

    @api recordId;
    @api name;
    @api title;
    @api mediumPhotoUrl;
    @api viewProfileLabel;

    /**
     * get user Id from data-id dataset; send to user's profile page
     * @param event
     */
    handleProfileClick(event) {
        event.preventDefault();
        const recordId = event.target.dataset.id;
        console.log(recordId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'PersonAccount',
                actionName: 'view'
            }
        });
    }

}