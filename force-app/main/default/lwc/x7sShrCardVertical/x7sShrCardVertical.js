import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {classSet} from 'c/x7sShrUtils';
import { getText, getInteger } from 'c/x7sShrUtils';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class x7sShrCardHorizontal extends NavigationMixin(LightningElement) {
    @api avatarAlignment = 'default'; // default, center
	@api avatarBorderRadius = '';
	@api avatarMargin = '24px';
	@api avatarSize = '92px';
	@api customClass = '';
	@api description;
	@api descriptionLines = '0';
	@api emphasizeAvatarBackground = false;
	@api href = '';
	@api imageSrc;
	@api imageLabel;
	@api imagePlaceholderIcon = 'utility:screen';
	@api imageHeight = '200px'; // Forces a specific height on the images to be set vertically.
	@api iconOpacity = ".3";
	@api iconColor = "";
	@api imageBackgroundSize = 'cover'; // cover, contain, and auto
	@api imageBackgroundColor = '#eee';
	@api recordId = '';
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
	@api variant = 'default'; // default, featured

	@track hasFooter = true;
	    
	renderedCallback() {
		this.checkHasFooter();
	}
	
	handleFooterSlotChange() {
		this.checkHasFooter();
	}
	
    handleTitleClick(evt) {
		if (!this.useHrefOnly){
			// Stop the event's default behavior.
			// Stop the event from bubbling up in the DOM.
			evt.preventDefault();
			evt.stopPropagation();
			// Allow the controlling component to handle the event, similar to:
			// <c-x7s-shr-card-vertical record-id={recordId} ontitleclick={clickHandler}></c-x7s-shr-card-vertical>
			// Simply using `onclick` for the event attribute fires on the entire LWC component, not just on the anchor tag
			this.dispatchEvent(new CustomEvent('titleclick', { detail: this.recordId }));
		}
	}

	checkHasFooter() {
		const slot = this.template.querySelector("slot[name='footer']");
		// { flatten: true } - If the flatten option is set to true, it also returns the assigned elements of any other slots that are descendants of this slot.
		// We need this because of complex nested slot structures - like passing a slot through another wrapper component which has a slot
		this.hasFooter = slot && slot.assignedElements({flatten: true}).length !== 0;
	}
	
	// Automatically aligns the avatar to center if using a featured variant
	get calculatedAvatarAlignment() {
		if(this.variant==='featured') {
			return 'center'
		}
		return this.avatarAlignment;
	}

	// If there is no image background then don't use the image-height-horizontal and calculate the correct height
	get calculatedImageHeight() {
		if(this.hideAvatarBackground) {
			// featured variants add the padding automatically
			if (this.variant === 'featured') {
				return (getInteger(this.avatarSize) + (getInteger(this.avatarMargin) * 2)) + getText(this.avatarSize);
			}
			return this.avatarSize;
		}
		return this.imageHeight;
	}

	get componentClass() {
		return classSet(`card-vertical ${this.customClass} `)
			.add({
				'card_has-avatar': this.useAvatar,
				'card_has-image': this.showImage,
				'card_no-image': !this.showImage && !this.showPlaceholderImage,
				'card_variant-featured': this.variant === 'featured',
				'card_emphasize-avatar-background': this.emphasizeAvatarBackground,
			})
			.toString();
	}
	
	get componentStyle() {
		return '';
	}
	
	get contentClass() {
		return classSet(`card__content `)
			.add({
				'slds-text-align_left': this.textAlign === 'left',
				'slds-text-align_center': this.textAlign === 'center',
				'slds-text-align_right': this.textAlign === 'right',
			})
			.toString();
	}
	
	get bodyClass() {
		return classSet('card__body')
			.add({
				'slds-p-top_large slds-p-bottom_large': this.layout === 'vertical' || this.variant === 'featured',
				'slds-p-left_large slds-p-right_large': this.variant === 'featured'
			})
			.toString();
	}
    
    get imageStyle() {
		let imageWrapperStyle = this.calculatedImageHeight !== '' ? `height: ${this.calculatedImageHeight};` : '';
		
		return imageWrapperStyle;
	}

    get showImage() {
        if ( this.hideImage || 
			(this.hidePlaceholderImage && this.hideAvatar)
		) {
			return false;
        }
        // If there is an image or we aren't hiding the placeholder image
		return (this.imageSrc && this.imageSrc !== '' || !this.hidePlaceholderImage);
	}

	get footerClass() {
		return classSet('card__footer slds-p-bottom_large')
			.add({
				// 'slds-p-bottom_large': true
			})
			.toString();
	}
	
	get footerStyle() {
		return `margin-left: 0;`;
	}
	
	get showFooter() {
		if (this.hideFooter) {
			return false;
		}
		return this.hasFooter;
	}
}