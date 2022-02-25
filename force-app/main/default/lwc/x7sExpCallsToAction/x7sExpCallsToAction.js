/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';
import {classSet} from 'c/x7sShrUtils';

export default class X7sExpCallsToAction extends LightningElement {
    @api title;
    @api titleAlign = 'Left'; // Left, Center, Right
    @api titleColor;
    @api totalItems = '4';
    @api layout = 'Base Layout';

    @api ctaText1 = 'Item 1 Text';
    @api ctaDescription1 = '';
    @api ctaURL1 = 'http://www.example.com';
    @api ctaImage1 = 'utility:new';
    @api useText1 = false;
    @api ctaBackgroundSize1 = 'Cover'; // Cover, Contain
    @api iconColor1;
    @api ctaBackgroundColor1 = '';
    @api ctaTextColor1;
    @api ctaOverlay1 = false;

    @api ctaText2 = 'Item 2 Text';
    @api ctaDescription2 = '';
    @api ctaURL2 = 'http://www.example.com';
    @api ctaImage2 = 'utility:new';
    @api useText2 = false;
    @api ctaBackgroundSize2 = 'Cover'; // Cover, Contain
    @api iconColor2;
    @api ctaBackgroundColor2 = '';
    @api ctaTextColor2;
    @api ctaOverlay2 = false;

    @api ctaText3 = 'Item 3 Text';
    @api ctaDescription3 = '';
    @api ctaURL3 = 'http://www.example.com';
    @api ctaImage3 = 'utility:new';
    @api useText3 = false;
    @api ctaBackgroundSize3 = 'Cover'; // Cover, Contain
    @api iconColor3;
    @api ctaBackgroundColor3 = '';
    @api ctaTextColor3;
    @api ctaOverlay3 = false;

    @api ctaText4 = 'Item 4 Text';
    @api ctaDescription4 = '';
    @api ctaURL4 = 'http://www.example.com';
    @api ctaImage4 = 'utility:new';
    @api useText4 = false;
    @api ctaBackgroundSize4 = 'Cover'; // Cover, Contain
    @api iconColor4;
    @api ctaBackgroundColor4 = '';
    @api ctaTextColor4;
    @api ctaOverlay4 = false;

    @api ctaText5 = 'Item 5 Text';
    @api ctaDescription5 = '';
    @api ctaURL5 = 'http://www.example.com';
    @api ctaImage5 = 'utility:new';
    @api useText5 = false;
    @api ctaBackgroundSize5 = 'Cover'; // Cover, Contain
    @api iconColor5;
    @api ctaBackgroundColor5 = '';
    @api ctaTextColor5;
    @api ctaOverlay5 = false;

    @api ctaText6 = 'Item 6 Text';
    @api ctaDescription6 = '';
    @api ctaURL6 = 'http://www.example.com';
    @api ctaImage6 = 'utility:new';
    @api useText6 = false;
    @api ctaBackgroundSize6 = 'Cover'; // Cover, Contain
    @api iconColor6;
    @api ctaBackgroundColor6 = '';
    @api ctaTextColor6;
    @api ctaOverlay6 = false;

    @api ctaText7 = 'Item 7 Text';
    @api ctaDescription7 = '';
    @api ctaURL7 = 'http://www.example.com';
    @api ctaImage7 = 'utility:new';
    @api useText7 = false;
    @api ctaBackgroundSize7 = 'Cover'; // Cover, Contain
    @api iconColor7;
    @api ctaBackgroundColor7 = '';
    @api ctaTextColor7;
    @api ctaOverlay7 = false;

    @api ctaText8 = 'Item 8 Text';
    @api ctaDescription8 = '';
    @api ctaURL8 = 'http://www.example.com';
    @api ctaImage8 = 'utility:new';
    @api useText8 = false;
    @api ctaBackgroundSize8 = 'Cover'; // Cover, Contain
    @api iconColor8;
    @api ctaBackgroundColor8 = '';
    @api ctaTextColor8;
    @api ctaOverlay8 = false;

    @api ctaText9 = 'Item 9 Text';
    @api ctaDescription9 = '';
    @api ctaURL9 = 'http://www.example.com';
    @api ctaImage9 = 'utility:new';
    @api useText9 = false;
    @api ctaBackgroundSize9 = 'Cover'; // Cover, Contain
    @api iconColor9;
    @api ctaBackgroundColor9 = '';
    @api ctaTextColor9;
    @api ctaOverlay9 = false;

    @api ctaText10 = 'Item 10 Text';
    @api ctaDescription10 = '';
    @api ctaURL10 = 'http://www.example.com';
    @api ctaImage10 = 'utility:new';
    @api useText10 = false;
    @api ctaBackgroundSize10 = 'Cover'; // Cover, Contain
    @api iconColor10;
    @api ctaBackgroundColor10 = '';
    @api ctaTextColor10;
    @api ctaOverlay10 = false;

    @api textAlign = 'Center'; // Left, Center, Right
    @api textTransform;
    @api ctaDefaultColor;
    @api fontSize = '1rem';
    @api ctaBorderRadius = '3px';
    @api ctaDefaultBack = '';
    @api ctaDefaultIconSize = 'small'; // xx-small, x-small, small, medium, or large
    @api ctaHeight = '80px';
    @api ctaDefaultIconColor;
    @api ctaOverlayColor;
    @api ctaOverlayColorHover;
    @api ctaSpacing = 2;
    @api itemsPerRowBase = '2';
    @api itemsPerRowSmall = '2';
    @api itemsPerRowMedium = '4';
    @api itemsPerRowLarge = 'auto';
    @api verticalAlign = 'Center'; // Start, Center, End
    @api customClassName;

    @track ctaData = [];
    @track flexibility = 'auto';

    debug = false;

    /**
     * Returns true if set to "Base Layout"
     * @returns {boolean}
     */
    get baseLayout() {
        return this.layout === 'Base Layout';
    }

    /**
     * Return class names for the root element
     * @returns {string}
     */
    get componentClass() {
        let classes = 'x7s-call-to-action';
        classes += this.customClassName ? ` ${this.customClassName}` : ``;
        return classes;
    }

    /**
     * Set the alignment of the title
     * @returns {string}
     */
    get titleClass() {
        return classSet('slds-text-heading_medium')
            .add({
                'slds-text-align_left': this.titleAlign.toLowerCase() === 'left',
                'slds-text-align_center': this.titleAlign.toLowerCase() === 'center',
                'slds-text-align_right': this.titleAlign.toLowerCase() === 'right'
            })
            .toString();
    }

    /**
     * Returns inline styles for the title
     * @returns {string}
     */
    get titleStyle() {
        return this.titleColor ? `color: ${this.titleColor}` : '';
    }

    /**
     * Returns inline styles for the grid row
     * @returns {string}
     */
    get rowStyles() {
        let styles = `margin-left: -${this.ctaSpacing / 2}px;`;
        styles += `margin-right: -${this.ctaSpacing / 2}px;`;
        return styles;
    }

    /**
     * Returns inline styles for the grid columns
     * @returns {string}
     */
    get colStyles() {
        let styles = `padding: ${this.ctaSpacing / 2}px;`;
        return styles;
    }

    /**
     * Returns the base column sizes
     * @returns {string}
     */
    get colWidthBase() {
        return this.itemsPerRowBase === 'auto' ? 'auto' : 12 / this.itemsPerRowBase;
    }

    /**
     * Returns the small column sizes
     * @returns {string}
     */
    get colWidthSmall() {
        return this.itemsPerRowSmall === 'auto' ? 'auto' : 12 / this.itemsPerRowSmall;
    }

    /**
     * Returns the medium column sizes
     * @returns {string}
     */
    get colWidthMedium() {
        return this.itemsPerRowMedium === 'auto' ? 'auto' : 12 / this.itemsPerRowMedium;
    }

    /**
     * Returns the large column sizes
     * @returns {string}
     */
    get colWidthLarge() {
        return this.itemsPerRowLarge === 'auto' ? 'auto' : 12 / this.itemsPerRowLarge;
    }

    /**
     * Returns classes for the grid columns
     * @returns {string}
     */
    get colClass() {
        let classes = 'slds-col';
        classes += ` slds-size_${this.colWidthBase}-of-12`;
        classes += ` slds-small-size_${this.colWidthSmall}-of-12`;
        classes += ` slds-medium-size_${this.colWidthMedium}-of-12`;
        classes += ` slds-large-size_${this.colWidthLarge}-of-12`;
        return classes;
    }

    /**
     * Return lower case value of verticalAlign
     * @returns {string}
     */
    get verticalAlignLower() {
        return this.verticalAlign.toLowerCase();
    }

    /**
     * Return lower case value of textAlign
     * @returns {string}
     */
    get textAlignLower() {
        return this.textAlign.toLowerCase();
    }

    connectedCallback() {
        this.createDataObjects();
    }

    /**
     * Create an array of objects from the data
     */
    createDataObjects() {
        const length = parseInt(this.totalItems, 10);

        for (let i = 0; i < length; i++) {
            const key = i + 1;
            let object = {};
            let iconImage = this[`ctaImage${key}`];
            let image = iconImage;

            // If using icon name as text, strip to 4 characters
            if (this[`useText${key}`] && !this.baseLayout) {
                iconImage = iconImage.substring(0, 4).toUpperCase();
            }

            // To avoid errors, if the image is an icon, set it to blank for bitmap images
            if (image.includes(':')) {
                const regExp = new RegExp("^(http|https)://", "i");

                if (regExp.test(image)) {
                    iconImage = '';
                }
                else {
                    image = '';
                }
            }

            if (this[`iconColor${key}`] === undefined || this[`iconColor${key}`]==='') {
                if (this.ctaDefaultIconColor!=='') {
                   this[`iconColor${key}`]=this.ctaDefaultIconColor;
                }
            }

            object.key = key;
            object.text = this[`ctaText${key}`];
            object.description = this[`ctaDescription${key}`];
            object.url = this[`ctaURL${key}`];
            object.iconImage = iconImage;
            object.image = image;
            object.useText = this[`useText${key}`];
            object.bgSize = this[`ctaBackgroundSize${key}`];
            object.iconColor = this[`iconColor${key}`];
            object.bgColor = (this.ctaDefaultBack !== '' && this[`ctaBackgroundColor${key}`] === '') ? this.ctaDefaultBack : this[`ctaBackgroundColor${key}`];
            object.textColor = this[`ctaTextColor${key}`];
            object.overlay = !this[`ctaOverlay${key}`];

            this.ctaData.push(object);
        }

        if (this.debug) {
            console.log('ctaData', JSON.parse(JSON.stringify(this.ctaData)));
        }
    }
}