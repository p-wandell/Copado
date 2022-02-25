/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class X7sExpFeaturedUserCard extends NavigationMixin(LightningElement) {

    @api viewProfileLabel;
    @api recordId;
    @api intro;
    @api ctaText;
    @api ctaLink;
    @api displayType;
    @api name;
    @api userTitle;
    @api communityNickname;
    @api mediumPhotoUrl;

    /**
     * get the value of the CTA link; if it contains http or https, open link in new window
     * if not, send link to navigateToCommunityPage()
     * @param event
     */
    handleCtaClick(event) {
        const link = event.target.value;
        const reg = new RegExp("^(http|https)://", "i");
        const match = reg.test(link);

        if (match){
            window.open(link, '_blank');
        } else {
            this.navigateToCommunityPage(link);
        }
    }

    /**
     * navigate to community page
     * @param page
     */
    navigateToCommunityPage(page) {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: page
            },
        });
    }

    /**
     * get user Id from dataset; send to user's profile page
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

    /**
     * check if display type = "Banner"
     * @returns {boolean}
     */
    get isBanner() {
        return this.displayType === 'Banner';
    }

    /**
     * banner style
     * @returns {string} inline style with MediumPhotoUrl as background image
     */
    get bannerStyle() {
        return `background-image:url(${this.mediumPhotoUrl});`;
    }

    /**
     * if displayType = Banner, use the -slds-card style to add a border around the container
     * @returns {string}
     */
    get displayTypeStyle() {
        return this.displayType === 'Banner' ? `slds-card` : ``;
    }
}