/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-16.
*/
import {LightningElement, track, api, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
export default class x7SCommunityLogo extends NavigationMixin(LightningElement) {
    @api customId;
    @api customClass;
    @api communityTitle;
    @api link;
    @api communityLogo;
    @track wrapperClass;
    @track showTitle;
    renderedCallback() {
        this.wrapperClass = this.customClass != null ? 'x7SCommunityLogo ' + this.customClass : 'x7SCommunityLogo';
        this.showTitle = this.communityTitle != null;
    }
    linkClick(event){
        const url = event.currentTarget.getAttribute('href');
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('urlclick', {detail: {url: url}}));
    }
}