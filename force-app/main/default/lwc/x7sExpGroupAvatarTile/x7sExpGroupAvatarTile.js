/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class X7sExpGroupAvatarTile extends NavigationMixin(LightningElement) {
    // Parameters
    @api showDescription;
    @api showMembers;
    @api group; // the group object should contain the following attributes:
                // BannerPhotoUrl, Description, FullPhotoUrl, Id, MemberCount, Name and SmallPhotoUrl
    @api hasValidGroup = false;

    /**
     * Upon connection check to see if this.group has come over
     * If so, set hasValidGroup to true for displaying this block
     */
    connectedCallback(){
        if(this.group && this.group.hasOwnProperty('Id')){
            this.hasValidGroup = true;
        }
    }

    /**
     * Navigates to the group page
     * @param event
     */
    navigateToGroup(event){
        let groupId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: groupId,
                objectApiName: 'Group',
                actionName: 'view'
            }
        });
    }
}