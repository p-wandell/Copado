/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { classSet } from 'c/x7sShrUtils';

export default class X7sShrTile extends NavigationMixin(LightningElement) {
    /* Data Attributes */
    @api customClass = '';
    @api title = '';
    @api description = '';
    @api recordId;
    @api imageSrc = '';
    @api iconName = '';
    @api iconText = '';
    @api link = '';

    /* Display Attributes */
    @api backgroundColor;
    @api backgroundSize;
    @api borderRadius = '2px';
    @api descriptionColor;
    @api descriptionColorHover;
    @api hideDescription = false;
    @api hideImage = false;
    @api hideIcon = false;
    @api hideOverlay = false;
    @api horizontalAlignment = 'center'; // left, center, right
    @api iconColor;
    @api iconFontSize;
    @api imageHeight = '48px';
    @api imageWidth = '48px';
    @api overlayColor;
    @api overlayColorHover;
    @api reduceAnimation = false;
    @api titleColor;
    @api titleColorHover;
    @api titleSize;
    @api titleTextTransform;
    @api verticalAlignment = 'center'; // start, center, end

    /* Internal Attributes */
    linkTarget = '_self';
    isHovering = false;

    connectedCallback() {
        this.setUpHref();
    }

    /**
     * Check if the link attribute is set.
     * Otherwise attempt to use the recordId (used in x7sFeaturedTopics)
     */
    setUpHref() {
        if (this.link) {
            // Check if the link starts with https or https
            const reg = new RegExp("^(http|https)://", "i");
            const newWindow = reg.test(this.link);

            // If it does, open in a new window
            this.linkTarget = newWindow ? '_blank' : '_self';
        } else {
            this.recordPageRef = {
                type: "standard__recordPage",
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            };
            this[NavigationMixin.GenerateUrl](this.recordPageRef)
                .then(tileUrl => this.link = tileUrl);
        }
    }

    handleBlur() {
        this.isHovering = false;
    }

    handleFocus() {
        this.isHovering = true;
    }

    get showDescription() {
        return !this.hideDescription && this.description && this.description !== '';
    }
    get showImage() {
        return !this.hideImage && this.imageSrc && this.imageSrc !== '';
    }
    get showIcon() {
        return !this.hideIcon && this.iconName && this.iconName !== '';
    }
    get showOverlay() {
        return !this.hideOverlay;
    }

    /* Classes and Styling */
    get componentClass() {
        return classSet('x7s-tile slds-grid')
            .add({
                'slds-text-align_left': this.horizontalAlignment.toLowerCase() === 'left',
                'slds-text-align_center': this.horizontalAlignment.toLowerCase() === 'center',
                'slds-text-align_right': this.horizontalAlignment.toLowerCase() === 'right',
                'slds-grid_vertical-align-start': this.verticalAlignment.toLowerCase() === 'start',
                'slds-grid_vertical-align-center': this.verticalAlignment.toLowerCase() === 'center',
                'slds-grid_vertical-align-end': this.verticalAlignment.toLowerCase() === 'end',
                'x7s-tile_animated': !this.reduceAnimation
            })
            .toString();
    }
    get tileStyle() {
        let tileStyle = '';
        tileStyle += `border-radius: ${this.borderRadius};`;
        tileStyle += this.backgroundColor !== '' ? `background-color: ${this.backgroundColor};` : '';
        tileStyle += this.imageHeight !== '' ? `height: ${this.imageHeight};` : '';
        tileStyle += this.imageWidth !== '' ? `max-width: ${this.imageWidth};` : '';
        return tileStyle;
    }
    get descriptionStyle() {
        return `color: ${this.isHovering ? this.descriptionColorHover : this.descriptionColor};`;
    }
    get imageStyle() {
        return `background-image: url(${this.imageSrc}); ${this.backgroundSize ? 'background-size: ' + this.backgroundSize + ';' : ''}`;
    }
    get overlayStyle() {
        return `background-color: ${this.isHovering ? this.overlayColorHover : this.overlayColor};`;
    }
    get titleStyle() {
        return `color: ${this.isHovering ? this.titleColorHover : this.titleColor}; ${this.titleSize ? 'font-size: ' + this.titleSize + ';' : ''} ${this.titleTextTransform && this.titleTextTransform !== 'inherit' ? 'text-transform: ' + this.titleTextTransform + ';' : ''}`;
    }
}