/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';

export default class x7sExpBanner extends LightningElement {
    // Builder properties
    @api container = "x-large";
    @api columns = "1";
    @api backgroundColor = "#333333";
    @api backgroundImage;
    @api fixed;
    @api horizontalPadding = "large";
    @api verticalPadding = "large";
    @api overlayColor;
    @api overlayOpacity;
    @api darkText = "false";
    @api centered;
    @api verticalAlignment;

    @api headlineSize = 'large';
    @api headlineTag = 'h1';
    @api subHeadlineSize = 'medium';
    @api subHeadlineTag = 'h2';

    @api headline;
    @api subHeadline;
    @api paragraph;
    @api buttonText;
    @api buttonUrl;
    @api buttonText2;
    @api buttonUrl2;

    @api headline2;
    @api subHeadline2;
    @api paragraph2;
    @api button2Text;
    @api button2Url;
    @api button2Text2;
    @api button2Url2;

    @api headline3;
    @api subHeadline3;
    @api paragraph3;
    @api buttonText3;
    @api buttonUrl3;
    @api button2Text3;
    @api button2Url3;

    @api customClassName;
    @api align = "left";

    /**
     * Getter for whether it is 1 column or not
     * @returns {boolean}
     */
    get is1Column(){
        return this.columns === '1';
    }

    /**
     * Getter for whether it is 2 columns or not
     * @returns {boolean}
     */
    get is2Column(){
        return this.columns === '2';
    }

    /**
     * Getter for whether it is 3 columns or not
     * @returns {boolean}
     */
    get is3Column(){
        return this.columns === '3';
    }

    /**
     * Returns a string of classes based upon builder properties
     * @returns {string}
     */
    get sectionClasses(){
        let classString = 'x7s-banner ';
        // Check if customClassName is defined before setting
        if(this.customClassName){
            classString += this.customClassName + ' ';
        }
        // Apply inverse text color if this.darkText === false
        if(!this.darkText){
            classString += 'slds-text-color_inverse ';
        }
        return classString;
    }

    /**
     *
     * @returns {string}
     */
    get outerDivStyles(){
        let style = '';
        if(this.backgroundColor){
            style += `background-color:${this.backgroundColor};`;
        }
        if(this.backgroundImage){
            style += `background-image:url(${this.backgroundImage});background-size:cover;`;
        }
        if(this.fixed){
            style += 'background-attachment:fixed;';
        }
        return style;
    }

    /**
     * Returns a string with overlay styles including color and opacity
     * @returns {string}
     */
    get overlayStyles(){
        return `background: ${this.overlayColor}; opacity: ${this.overlayOpacity}`;
    }

    /**
     * Returns a string that includes both sets of padding classes as defined in the builder
     * @returns {string}
     */
    get paddingClasses(){
        return `${this.verticalPaddingClass} ${this.horizontalPaddingClass}`;
    }

    // object-literal lookup maps the user-friendly attribute to an SLDS class name
    get verticalAlignmentType(){
        let variant = {
            'Top': 'start',
            'Middle': 'center',
            'Bottom': 'end',
            'default': 'start'
        };
        return variant[this.verticalAlignment] || variant['default'];
    }

    // object-literal lookup maps the user-friendly attribute to an SLDS padding class name
    get verticalPaddingClass() {
        let map = {
            'none': '',
            'xx-large': 'slds-p-vertical_xx-large',
            'x-large': 'slds-p-vertical_x-large',
            'large': 'slds-p-vertical_large',
            'medium': 'slds-p-vertical_medium',
            'small': 'slds-p-vertical_small',
            'x-small': 'slds-p-vertical_x-small',
            'xx-small': 'slds-p-vertical_xx-small'
        };
        return map[this.verticalPadding] || map['none'];
    }

    get horizontalPaddingClass() {
        let map = {
            'none': '',
            'xx-large': 'slds-p-horizontal_xx-large',
            'x-large': 'slds-p-horizontal_x-large',
            'large': 'slds-p-horizontal_large',
            'medium': 'slds-p-horizontal_medium',
            'small': 'slds-p-horizontal_small',
            'x-small': 'slds-p-horizontal_x-small',
            'xx-small': 'slds-p-horizontal_xx-small'
        };
        return map[this.horizontalPadding] || map['none'];
    }

    get containerClasses() {
        let map = {
            'none': '',
            'x-large': 'slds-container_x-large',
            'large': 'slds-container_large',
            'medium': 'slds-container_medium',
            'small': 'slds-container_small'
        };
        return `slds-container_center ${map[this.container] || map['none']}`;
    }
}