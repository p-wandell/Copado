/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {classSet} from 'c/x7sShrUtils';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class X7sShrCard extends NavigationMixin(LightningElement) {
	@api avatarAlignment = 'default'; // default, center
	@api avatarSize = '92px';
	@api avatarBorderRadius = '';
	@api customClass = '';
	@api description;
	@api descriptionLines = '0';
	@api emphasizeAvatarBackground = false;
	@api href;
	@api imageSrc;
	@api imageHeight = '200px';
	@api imageLabel;
	@api imagePlaceholderIcon = 'utility:screen';
	@api imageWidthHorizontal = ''; // Forces a specific width to be set horizontally. Otherwise, uses styling. Vertical Image Width is always 100%.
	@api iconOpacity = ".3";
	@api iconColor = "";
	@api imageBackgroundSize = 'cover'; // cover, contain, and auto
	@api imageBackgroundColor = '#eee';
	@api recordId;
	@api textAlign = 'left';
	@api minHeight = '';
	@api title;
	@api titleLines = '0';
	@api topics;
	@api hideAvatar = false;
	@api hideAvatarBackground = false;
	@api hideFooter = false;
	@api hideImage = false;
	@api hidePlaceholderImage = false;
	@api useAvatar = false;
	@api useHrefOnly = false; // Forces the event handler to only rely on what is entered in the "href" of the anchor link
	@api layout = 'vertical'; // vertical, horizontal
	@api variant = 'default'; // default, featured

	@track cardUrl;
	@track hasFooter = true;

	connectedCallback() {
		if (this.useHrefOnly) {
			this.cardUrl = this.href;
		} else {
			this.recordPageRef = {
				type: "standard__recordPage",
				attributes: {
					recordId: this.recordId,
					actionName: 'view'
				}
			};

			this[NavigationMixin.GenerateUrl](this.recordPageRef)
				.then(cardUrl => { this.cardUrl = cardUrl });
		}
	}

	get horizontalLayout() {
		return this.layout === 'horizontal';
	}

	get verticalLayout() {
		return this.layout === 'vertical';
	}
	
	handleTitleClick(evt) {
		if (!this.useUrlOnly){
			// Stop the event's default behavior.
			// Stop the event from bubbling up in the DOM.
			evt.preventDefault();
			evt.stopPropagation();

			this[NavigationMixin.Navigate](this.recordPageRef);
		}
	}
}