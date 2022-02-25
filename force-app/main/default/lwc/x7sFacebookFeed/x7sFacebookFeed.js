/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, wire} from 'lwc';

export default class X7SFacebookFeed extends LightningElement {
    @api title = 'Facebook Feed';
    @api subTitle;
    @api align = 'left';

    // Facebook settings taken from https://developers.facebook.com/docs/plugins/page-plugin/
    @api facebookUrl = 'https://www.facebook.com/7SummitsInc/';
    @api width = 340;
    @api height = 500;
    @api timelineTab = false;
    @api eventsTab = false;
    @api messagesTab = false;
    @api hideCover = false;
    @api showFacePile = false;
    @api hideCTA = false;
    @api smallHeader = false;
    @api environmentType = 'Standard'; // Standard, Community
    @api variant = 'slds-card'; // default, slds-card, featured
    @api appId;

    adaptContainerWidth = true;

    /**
     * Assemble the Facebook embed URL
     * @returns {string} - url
     */
    get facebookHref() {
        const baseUrl = 'https://www.facebook.com/plugins/page.php';
        const pageUrl = `?href=${encodeURIComponent(this.facebookUrl)}`;
        const width = `&width=${this.width}`;
        const height = `&height=${this.height}`;
        const smallHeader = `&small_header=${this.smallHeader}`;
        const hideCover = `&hide_cover=${this.hideCover}`;
        const showFacePile = `&show_facepile=${this.showFacePile}`;
        const adaptContainerWidth = `&adapt_container_width=${this.adaptContainerWidth}`;
        const appId = this.appId ? `&appId=${this.appId}` : '';
        const tabSet = [];
        let tabs;

        if (this.timelineTab) {
            tabSet.push('timeline');
        }

        if (this.eventsTab) {
            tabSet.push('events');
        }

        if (this.messagesTab) {
            tabSet.push('messages');
        }

        tabs = `&tabs=${tabSet.join(',')}`;

        return baseUrl + pageUrl + tabs + width + height + smallHeader + adaptContainerWidth + hideCover +showFacePile + appId;
    }
}