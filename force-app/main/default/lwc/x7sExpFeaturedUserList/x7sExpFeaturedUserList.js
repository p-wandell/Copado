/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import getUserListInformation from '@salesforce/apex/x7sExpFeaturedUserController.getUserListInformation';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';

// static resources
import jQuery from '@salesforce/resourceUrl/x7sExpJquery';
import SlickJS from '@salesforce/resourceUrl/x7sExpSlickJS';

export default class X7sExpFeaturedUserList extends LightningElement {

    @api title = 'Featured Users';
    @api titleAlignment = 'left';
    @api viewProfileLabel = 'View Profile';
    @api userIds;
    @api isNarrow = false;
    @api displayType = 'List';
    @api showCarouselArrows = false;
    @api showCarouselDots = false;
    @api customClass;

    @track userIdArray;
    @track users; // array of user objects returned from apex
    label = {labelAriaWrapper};

    connectedCallback() {
        this.userIds ? this.userIdArray = this.userIds.split(',') : this.userIdArray = [];
    }

    slickJsInitialised = false;

    /**
     * @description Standard lifecycle method 'renderedCallback'
     *              Ensures that the page loads and renders the
     *              container before doing anything else50
     *
     */
    renderedCallback() {

        // Performs this operation only on first render
        if (this.slickJsInitialised) {
            return;
        }
        this.slickJsInitialised = true;

        Promise.all([
            loadScript(this, jQuery + '/jquery-3.3.1-min.js'),
            loadStyle(this, SlickJS + '/slick/slick.css'),
            loadStyle(this, SlickJS + '/slick/slick-theme.css')
        ]).then(() => {
            // load slick after jQuery
            loadScript(this, SlickJS + '/slick/slick.min.js')
                .then(() => {
                    this.initialiseSlickJs();
                })
                .catch(error => {
                    this.error = error;
                });
        }).catch(error => {
            // eslint-disable-next-line no-console
            console.error({
                message: 'Error occurred on SlickJS',
                error
            });
        })
    }

    /**
     * @description Initialise the slickJS configuration
     *              This is where we configure the available options for the slider.
     */
    async initialiseSlickJs() {

        // console.log('userIdArray', this.userIdArray);

        getUserListInformation({
            userIds: this.userIdArray
        })
        .then(result => {

             //console.log('users result', JSON.stringify(result));
             //console.log('users', result);

            if(result && result.length > 0) {

                const showCarouselDots = result.length === 1 ? false : this.showCarouselDots;
                const showCarouselArrows = result.length === 1 ? false : this.showCarouselArrows;

                this.users = result;

                // slickJS takes over the DOM so we need to insert the slides declaratively
                // use lwc:dom="manual" on the element
                // https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.create_third_party_library
                //
                // build the markup using a template literal
                // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals
                // const announcementList = this.announcements.results;
                const markup = `
                ${result.map(item => `

                <article class="slds-card slds-m-around_xx-small">
                    <div class="slds-card__header slds-text-align_center">
                        <header class="slds-p-vertical_medium slds-is-relative">
                            <span class="slds-avatar slds-avatar_circle slds-is-relative">
                                <img src=${item.MediumPhotoUrl} data-id=${item.Id} alt=${item.Name} />
                            </span>
                        </header>
                    </div>
                    <div class="slds-card__body slds-card__body_inner slds-text-align_center">
                        <h5 class="slds-truncate"><em>${item.Name}</em></h5>
                        ${item.Title ? `<p>${item.Title}</p>` : ``}
                        <hr>
                    </div>
                    <footer class="slds-card__footer slds-text-align_center">
                        <a class="slds-card__footer-action" href="javascript:void(0);" data-id=${item.Id}>${this.viewProfileLabel}</a>
                    </footer>
                </article>

                `).join('')}`; // use the join('') method on the array to remove the commas between slides

                // get the carousel element
                const el = this.template.querySelector('div.carousel');

                // eslint-disable-next-line no-undef
                $(el).slick('slickAdd', markup,
                    $(el).slick({
                        dots: showCarouselDots,
                        arrows: showCarouselArrows,
                        infinite: true,
                        speed: 300,
                        slidesToShow: 2,
                        slidesToScroll: 1,
                        responsive: [
                            {
                                breakpoint: 640,
                                settings: {
                                    slidesToShow: 1,
                                    slidesToScroll: 1,
                                    infinite: true,
                                    dots: false,
                                    arrows: false,
                                    adaptiveHeight: true
                                }
                            }
                        ]
                    })
                );

                // delegated binding for profile click handler
                $(el).on('click', 'a.slds-card__footer-action', function (e) {
                    e.preventDefault();
                    let recordId = $(this).data("id")
                    let url = window.location.href.replace(/\/$/, ""); // get full url without trailing slash
                    let profileUrl = url.substring(0, url.lastIndexOf('/')) + '/profile/' + recordId; // create profile page url
                    window.open(profileUrl, '_self');
                });
            }
        })
        .catch(error => {
            this.error = error;
            console.log('error', error);
        });
    }

    get isList() {
        return this.displayType === 'List';
    }

    get isCards() {
        return this.displayType === 'Cards';
    }

    get isCarousel() {
        return this.displayType === 'Carousel';
    }

    get mediumDeviceSize() {
        return this.isNarrow ? 6 : 4;
    }

    get largeDeviceSize() {
        return this.isNarrow ? 6 : 3;
    }

}