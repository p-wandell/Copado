/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api} from 'lwc';
import {classSet } from 'c/x7sShrUtils';

export default class X7sShrIconLabel extends LightningElement {
  @api icon;                    // slds icon name or URL to custom SVG(if iconSVG is set to true).
  @api iconSVG = false;         // Are we using custom SVG instead of slds icons?
  @api iconPosition;            // Options include: 'left', 'right', 'above-center', 'above-left'
  @api iconSize;                // Options include: 'xx-small', 'x-small', 'small', 'medium', 'large'

  // dynamic variables below -- do not set.
  @api iconSrc;
  @api iconName;


  connectedCallback() {
    if(this.icon) {
      if(this.iconSVG) {
        this.iconSrc = this.icon;
      } else {
        this.iconName = this.icon;
      }
    }
  }


  get layoutClasses() {
    return classSet(`${this.featCustomClass}`)
      .add({
        'slds-grid_reverse': this.iconPosition === 'right',
        'slds-grid_vertical': this.iconPosition === 'above-center' || this.iconPosition === 'above-left',
        'slds-text-align_center': this.iconPosition === 'above-center'
      })
      .toString();
  }


  get iconClasses() {
    return classSet()
      .add({
        'slds-p-right_small': this.iconPosition === 'left',
        'slds-p-left_small': this.iconPosition === 'right',
        'slds-p-bottom_small': this.iconPosition === 'above-center' || this.iconPosition === 'above-left'
      })
      .toString();
  }
}