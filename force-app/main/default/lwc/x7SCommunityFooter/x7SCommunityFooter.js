/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-16.
*/
import {LightningElement, track, api, wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {loadScript, loadStyle} from 'lightning/platformResourceLoader';
import hiveLightning from '@salesforce/resourceUrl/x7S_HiveLightning';
import x7SUtils from 'c/x7SUtils';
export default class x7SCommunityFooter extends NavigationMixin(LightningElement) {
    @api customId;
    @api customClass;
    @api communityTitle = 'THE HIVE';
    @api linkText1;
    @api linkUrl1;
    @api linkNewTab1;
    @api linkText2;
    @api linkUrl2;
    @api linkNewTab2;
    @api linkText3;
    @api linkUrl3;
    @api linkNewTab3;
    @api linkText4;
    @api linkUrl4;
    @api linkNewTab4;
    @api linkText5;
    @api linkUrl5;
    @api linkNewTab5;
    @api companyLinkText;
    @api companyLinkUrl;
    @api companyLinkNewTab;
    @api communityLogo;
    @api facebookUrl;
    @api linkedinUrl;
    @api twitterUrl;
    @track wrapperClass;
    @track showCompanyLink = false;
    @track companyLinkTooltip;
    @track companyLinkTarget;
    @track showFacebook;
    @track showLinkedin;
    @track showTwitter;
    @track linkList = [];

    renderedCallback() {
        loadStyle(this, hiveLightning + '/fontAwesome/css/all.min.css');
        this.wrapperClass = this.customClass != null ? 'x7SCommunityFooter ' + this.customClass : 'x7SCommunityFooter';
        // When component rendered
        this.setLinks();

    }
    linkClick(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            }
        });
    }
    setLinks(){
        if(this.linkList.length === 0){
            for(let i = 1; i <= 5; i++){
                if(x7SUtils.isDefined(this['linkUrl' + i])){
                    let linkText = x7SUtils.isDefined(this['linkText' + i]) ? this['linkText' + i] : this['linkUrl' + i];
                    console.log(this['linkNewTab' + i]);
                    this.linkList.push({
                        text: linkText,
                        url: this['linkUrl' + i],
                        target: this['linkNewTab' + i] === true ? '_blank' : '',
                        tooltip: 'Navigate To ' + linkText
                    });
                }

            }
        }
        if(x7SUtils.isDefined(this.companyLinkUrl)){
            this.showCompanyLink = true;
            let linkText = x7SUtils.isDefined(this.companyLinkText) ? this.companyLinkText : this.companyLinkUrl;
            this.companyLinkTooltip = 'Navigate To ' + linkText;
            this.companyLinkTarget = this.companyLinkNewTab === true ? '_blank' : '';
        }
        this.showFacebook = x7SUtils.isDefined(this.facebookUrl);
        this.showLinkedin = x7SUtils.isDefined(this.linkedinUrl);
        this.showTwitter = x7SUtils.isDefined(this.twitterUrl);
    }
}