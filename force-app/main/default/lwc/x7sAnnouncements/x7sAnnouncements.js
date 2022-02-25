/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {loadScript, loadStyle} from 'lightning/platformResourceLoader';

import getActiveAnnouncements from '@salesforce/apex/x7sAnnouncementsController.getActiveAnnouncements';
import Id from '@salesforce/user/Id';
import jQuery from '@salesforce/resourceUrl/x7sAnnouncementsJquery331';
import SlickJS from '@salesforce/resourceUrl/x7sAnnouncementsSlickJS';

import {classSet, formatDate} from 'c/x7sShrUtils';

export default class x7sAnnouncements extends NavigationMixin(LightningElement) {

    @api numberOfResults = 5;
    @api useCarousel = false;
    @api autoplay = false;
    @api autoplaySpeed = 5;
    @api showArrows = false;
    @api showDots = false;
    @api showTitle = false;
    @api showAuthor = false;
    @api showDate = false;
    @api showIcon = false;
    @api displayChannel = 'Default';
    @api displayType = 'All';
    @api customClass = '';

    @track hiddenAnnouncements;
    @track cookieValues;
    @track arrowPadding = false; // add slds-p-horizontal for arrows
    @track loading = false;

    slickJsInitialised = false;
    debug = false;

    renderedCallback() {
        // Performs this operation only on first render
        if (this.slickJsInitialised) {
            return;
        }
        this.slickJsInitialised = true;

        Promise.all([
            loadScript(this, jQuery),
            loadStyle(this, SlickJS + '/slick/slick.css'),
            loadStyle(this, SlickJS + '/slick/slick-theme.css'),
            loadStyle(this, SlickJS + '/nucleo/css/style.css')
        ]).then(() => {
            // load slick after jQuery
            loadScript(this, SlickJS + '/slick/slick.min.js')
                .then(() => {
                    this.initializeSlickJs();
                })
                .catch(error => {
                    if (this.debug) {
                        // eslint-disable-next-line no-console
                        console.error({message: 'Error occurred loading SlickJS script', error});
                    }
                });
        }).catch(error => {
            if (this.debug) {
                // eslint-disable-next-line no-console
                console.error({message: 'Error occurred on SlickJS', error});
            }
        })
    }

    /**
     * Initialize the slickJS configuration
     * This is where we configure the available options for the slider.
     * @returns {Promise<void>}
     */
    async initializeSlickJs() {

        const useCarousel = this.useCarousel;
        let carouselLength;

        // exclude hidden announcements from cookie value
        this.hiddenAnnouncements = getCookieValues();

        this.loading = true;
        getActiveAnnouncements({
            numResultsString: this.numberOfResults,
            displayChannelString: this.displayChannel,
            displayTypeString: this.displayType,
            hiddenAnnouncementString: this.hiddenAnnouncements
        })
            .then(result => {
                if (this.debug) {
                    console.log('getActiveAnnouncements response', result);
                }

                if (result.results && result.results.length > 0) {

                    this.arrowPadding = this.useCarousel && this.showArrows && result.results.length > 1;

                    const slickInit = this.useCarousel && result.results.length > 1;
                    const showDots = result.results.length === 1 ? false : this.showDots;
                    const showArrows = result.results.length === 1 ? false : this.showArrows;
                    const autoplay = this.autoplay;
                    const autoplaySpeed = this.autoplaySpeed * 1000;

                    // Set length of carousel
                    carouselLength = result.results.length;

                    // slickJS takes over the DOM so we need to manually insert the slides into the DOM
                    // use lwc:dom="manual" on the element
                    // https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.create_third_party_library
                    const announcementList = result.results;
                    const slideHtml = `
                        ${announcementList.map(item => `
                        <div class="slds-notification-container slds-m-bottom_small" id="announcement-${item.Id}">
                            <div class="slds-notification ${item.Announcement_Type__c}" role="dialog">
                                <div class="slds-notification__body">
                                    <div class="slds-notification__target slds-media">
                                        ${this.showIcon ? `
                                        <div class="slds-media__figure">
                                            <i class="icon icon-24 ${this.announcementIcon(item.Announcement_Type__c)}">
                                                <span class="slds-assistive-text"${item.Announcement_Type__c}</span>
                                            </i>
                                        </div>` : ``}
                                        <div class="slds-media__body slds-p-right_x-large">
                                            ${this.showTitle ? `<h1>${item.Name}</h1>` : ``}
                                            <div>
                                                ${item.Announcement_Body__c ? item.Announcement_Body__c : ''}
                                                ${item.Announcement_URL__c && item.Announcement_Call_to_Action__c ? `<a class="slds-text-link" href="${item.Announcement_URL__c}">${item.Announcement_Call_to_Action__c}</a>` : ''}
                                            </div>
                                            ${this.showAuthor || this.showDate ?
                                                `<div class="slds-text-body_small">
                                                    Posted
                                                    ${this.showAuthor ? ` by ${item.Owner.Name}` : ``}
                                                    ${this.showDate ? ` on ${formatDate(item.Start_Date_Time__c, {month: 'long', day: 'numeric', year: 'numeric'})}` : ``}
                                                </div>` : ``}
                                        </div>
                                        ${item.Announcement_Dismissible__c ? `<a class="icon-close" id=${item.Id} aria-label=${item.Name}><i class="icon icon-24 icon-e-remove-2"><span class="slds-assistive-text">Close</span></i></a>` : ``}
                                    </div>
                                </div>
                            </div>
                        </div>`).join('')}`; // use the join('') method on the array to remove the commas between slides

                    // get the carousel element
                    const el = this.template.querySelector('div.x7s-announcements__items');

                    // get dot navigation element if showDots = true
                    const dotEl = showDots ? this.template.querySelector('div.slds-grid') : '';

                    // eslint-disable-next-line no-undef
                    setTimeout(function() {
                        // init Slick.js if useCarousel = true and there is more than 1 slide;
                        if (slickInit) {
                            $(el).slick('slickAdd', slideHtml,
                                $(el).slick({
                                    dots: showDots,
                                    appendDots: dotEl,
                                    arrows: showArrows,
                                    prevArrow: `<button type="button" class="slick-prev slds-show_medium"><i class="icon icon-lg icon-frame-c-arrow-left-2"><span class="slds-assistive-text">Previous announcement</span></i></button>`,
                                    nextArrow: `<button type="button" class="slick-next slds-show_medium"><i class="icon icon-lg icon-frame-c-arrow-right-2"><span class="slds-assistive-text">Next announcement</span></i></button>`,
                                    infinite: true,
                                    speed: 300,
                                    autoplay: autoplay,
                                    autoplaySpeed: autoplaySpeed,
                                    slidesToShow: 1,
                                    slidesToScroll: 1,
                                    adaptiveHeight: true,
                                    responsive: [
                                        {
                                            breakpoint: 640,
                                            settings: {
                                                slidesToShow: 1,
                                                infinite: true,
                                                dots: false
                                            }
                                        }
                                    ]
                                })
                            );
                        } else {
                            $(el).append(slideHtml);
                        }
                    }, 300); // set 300ms timeout to give data time to load

                    // delegated binding for dismiss click handler
                    $(el).on('click', 'a.icon-close', function (e) {
                        e.preventDefault();
                        let slideId = $(this).attr('id');
                        dismissAnnouncement(el, slideId);
                    });

                    // delegated binding for CTA click handler
                    $(el).on('click', 'a.slds-text-link', function (e) {
                        e.preventDefault();
                        const link = $(this).attr('href');
                        const reg = new RegExp("^(http|https)://", "i");
                        const match = reg.test(link);

                        if (match) {
                            window.open(link, '_blank');
                        } else {
                            window.open(link, '_self');
                        }

                    });
                }

            })
            .catch(error => {
                if (this.debug) {
                    // eslint-disable-next-line no-console
                    console.error({message: 'Error occurred on getActiveAnnouncements', error});
                }
            })
            .finally(() => {
                this.loading= false;
            });

        function dismissAnnouncement(el, slideId) {
            let userId = Id;
            let announcement = document.getElementById('announcement-' + slideId);
            let expire = new Date();
            expire = new Date(expire.getTime() +1000*60*60*24*365);
            let cookieValues = getCookieValues();
            if (cookieValues != null) {
                cookieValues += "," + slideId;
            } else {
                cookieValues = slideId;
            }

            // Remove from length
            carouselLength--;

            // create cookie
            document.cookie = 'announcements' +userId+ '=' + cookieValues + ';expires=' + expire.toGMTString() + ';';

            // hide dismissed slide
            if (useCarousel) {
                // if we're using the JS carousel, remove the carousel slide by current slide index
                removeDismissedSlide(el);
            } else {
                // if we're not using the carousel, just hide it with CSS
                announcement.classList.add("slds-hide");
            }
        }

        function removeDismissedSlide(el) {
            let currentSlide = $(el).slick('slickCurrentSlide');
            $(el).slick('slickRemove', currentSlide);

            // If there are no more slide, remove carousel
            if (carouselLength <= 0) {
                $(el).slick('unslick');
            }
        }

        function getCookieValues() {
            let name = "announcements" + Id;
            return (name = (document.cookie + ';').match(new RegExp(name + '=.*;'))) && name[0].split(/=|;/)[1];
        }

    }

    /**
     * return icon CSS class based on announcement type string
     * @param announcementType
     * @returns {string}
     */
    announcementIcon(announcementType) {
        let icon = '';
        switch(announcementType) {
            case 'info':
                icon = 'icon-c-info-2';
                break;
            case 'warning':
                icon = 'icon-t-warning-2';
                break;
            case 'error':
                icon = 'icon-s-ban';
                break;
            default:
                icon = 'icon-c-info-2';
        }
        return icon;
    }

    /**
     * return component class with option custom class
     * @returns {string}
     */
    get componentClass() {
        let classes = 'x7s-announcements';
        classes += this.showDots ? ' x7s-announcements__show-dots' : '';
        classes += this.customClass ? ` ${this.customClass}` : ``;
        return classes;
    }

    /**
     * return carousel class with conditional arrow padding
     * @returns {string}
     */
    get carouselClass() {
        return classSet('x7s-announcements__items')
            .add({
                'slds-p-horizontal_large': this.arrowPadding
            })
            .toString();
    }
}