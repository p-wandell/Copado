/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";

import jQuery from '@salesforce/resourceUrl/x7sExpJquery';
import SlickJS from '@salesforce/resourceUrl/x7sExpSlickJS';

import {stringifyStyles} from 'c/x7sShrUtils';

export default class X7sExpBannerSlider extends LightningElement {
    MAX_SLIDES = 3;

    @api title;

    @api backgroundImageUrl1;
    @api alignItems1 = "Left";
    @api headline1 = "7Summits";
    @api subHeadline1 = "Community Specialists";
    @api paragraph1 = "Welcome to the Community.";
    @api buttonText1 = "Learn More";
    @api buttonURL1 = "http://7summitsinc.com/";
    @api button2Text1 = "Learn More";
    @api button2URL1 = "http://7summitsinc.com/";
    @api darkText1 = false;
    @api showSlide1 = false;

    @api backgroundImageUrl2 = "";
    @api alignItems2 = "Left";
    @api headline2 = "7Summits";
    @api subHeadline2 = "Community Specialists";
    @api paragraph2 = "Welcome to the Community.";
    @api buttonText2 = "Learn More";
    @api buttonURL2 = "http://7summitsinc.com/";
    @api button2Text2 = "Learn More";
    @api button2URL2 = "http://7summitsinc.com/";
    @api darkText2 = false;
    @api showSlide2 = false;

    @api backgroundImageUrl3 = "";
    @api alignItems3 = "Left";
    @api headline3 = "7Summits";
    @api subHeadline3 = "Community Specialists";
    @api paragraph3 = "Welcome to the Community.";
    @api buttonText3 = "Learn More";
    @api buttonURL3 = "http://7summitsinc.com/";
    @api button2Text3 = "Learn More";
    @api button2URL3 = "http://7summitsinc.com/";
    @api darkText3 = false;
    @api showSlide3 = false;

    @api overlayColor = "#333333";
    @api overlayOpacity = '.7';

    @api transition = "Slide";
    @api autoplaySpeed = "8000";
    @api showDots = false;
    @api showArrows = false;
    @api height = "600px";

    @api customClassName = "";

    connectedCallback() {
        // Since we can't default parameters to true, lets automatically set show1 to true if none of the slides are set to show
        if(!this.showSlide1 && !this.showSlide2 &&!this.showSlide3){
            this.showSlide1 = true;
        }
    }

    /**
     * @description Standard lifecycle method 'renderedCallback'
     *              Ensures that the page loads and renders the
     *              container before doing anything else
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
            loadStyle(this, SlickJS + '/slick/slick-theme.css'),
            loadStyle(this, SlickJS + '/nucleo/css/style.css')
        ]).then(() => {
            // load slick after jQuery
            loadScript(this, SlickJS + '/slick/slick.min.js')
                .then(() => {
                    this.initializeSlickJs();
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
     * Generate HTML to be injected into a container DOM element (classname "x7s-banner-slider-container") and
     * then instantiate Slick slider to begin the carousel.
     */
    initializeSlickJs() {
        let slidesCount = 0;
        for(let i = 0; i < this.MAX_SLIDES + 1; i++) {
            if (this[`showSlide${i}`]) {
                slidesCount++;
            }
        }

        const slickInit = (slidesCount > 1);
        const showDots = slidesCount === 1 ? false : this.showDots;
        const showArrows = slidesCount === 1 ? false : this.showArrows;
        const autoplaySpeed = parseInt(this.autoplaySpeed, 10);
        const autoplay = (autoplaySpeed !== 0);
        const doFade = (this.transition === 'Fade');

        let slidesHtml = '';
        for (let i = 0; i < this.MAX_SLIDES + 1; i++) {
            if (this[`showSlide${i}`]) { slidesHtml += `
                <div class="slide" style="${stringifyStyles({'background-image': `url('${this['backgroundImageUrl' + i]}')`, 'height': this.height})}">
                    <div class="x7s-banner-overlay" style="${stringifyStyles({'background': this.overlayColor, 'opacity': this.overlayOpacity})}"></div>
                    <div class="slds-container_x-large slds-container_center slds-grid slds-wrap slds-grid_pull-padded slds-p-vertical_large" style="${stringifyStyles({'text-align': this[`alignItems${i}`]})}">
                        <div class="content slds-p-horizontal_small slds-size_1-of-1 slds-medium-size_2-of-1 slds-p-vertical_large">
                            <div class="x7s-component">
                                ${this[`headline${i}`] ? 
                                    `<div><h1 class="slds-text-heading_medium">${this[`headline${i}`]}</h1></div>` : ``}
                                ${this[`subHeadline${i}`] ?
                                    `<div><h2 class="slds-text-heading_medium">${this[`subHeadline${i}`]}</h2></div>` : ``}
                                <p class="slds-m-bottom_large">${this[`paragraph${i}`]}</p>

                                ${this[`buttonURL${i}`] ?
                                    `<a class="slds-button ${this[`darkText${i}`] ? 'slds-button_brand' : 'slds-button_inverse'}" href="${this[`buttonURL${i}`]}">${this[`buttonText${i}`]}</a>` : ``}
                                ${this[`button2URL${i}`] ?
                                    `<a class="slds-button ${this[`darkText${i}`] ? 'slds-button_brand' : 'slds-button_inverse'}" href="${this[`button2URL${i}`]}">${this[`button2Text${i}`]}</a>` : ``}
                            </div>
                        </div>
                    </div>
                </div>`;
            }
        }

        // get the carousel element
        const el = this.template.querySelector('.x7s-banner-slider-container');

        // eslint-disable-next-line no-undef
        setTimeout(function() {
            // init Slick.js if useCarousel = true and there is more than 1 slide;
            if(slickInit) {
                $(el).slick('slickAdd', slidesHtml,
                    $(el).slick({
                        dots: showDots,
                        autoplay: autoplay,
                        autoplaySpeed: autoplaySpeed,
                        arrows: showArrows,
                        fade: doFade,
                        mobileFirst: true
                    })
                );
            } else {
                $(el).append(slidesHtml);
            }
        }, 300); // set 300ms timeout to give data time to load
    }

    // - Value getters --------------------------------------------------------

    /**
     * return CSS class(es) on outer element
     *
     * @returns {string}
     */
    get componentClass() {
        let classes = ['x7s-banner-slider'];
        if (this.customClassName) classes.push(this.customClassName);
        return classes.join(' ');
    }
}