import {LightningElement, api, track} from 'lwc';
import {classSet} from 'c/x7sShrUtils';

export default class x7sShrCardImage extends LightningElement {
    // Global Options
    @api customClass = '';
    @api emphasizeBackground = false;

    // Avatar Options
    @api avatarAlignment = 'default'; // default, center
    @api avatarSize = '92px';
	@api avatarBorderRadius = '';
    @api hideAvatarBackground = false;
    @api useAvatar = false;

    // Image Options
	@api imageBackgroundSize = 'cover'; // cover, contain, and auto
	@api imageBackgroundColor = '#eee';
    @api imageSrc;
	@api imageLabel;
	@api imagePlaceholderIcon = 'utility:screen';

    // Icon Options
	@api iconOpacity = ".3";
    @api iconColor = "";
    
    // Placeholder Image Options
    @api hidePlaceholder = false;

    get componentClass() {
		return classSet(`card-image ${this.customClass} `)
			.add({
				'card-image_has-avatar': this.useAvatar,
				'card-image_has-image': this.showImage,
				'card-image_no-image': !this.showImage && !this.showPlaceholderImage,
				'card-image_emphasize-background': this.emphasizeBackground,
			})
			.toString();
	}


    get iconWrapperStyles() {
		var icoOpacity = this.iconOpacity ? this.iconOpacity : '0';
		
		return "opacity: " + icoOpacity + ";" +
			"color:" + this.iconColor + ";";
	}
	
	get avatarClass() {
		return classSet('card-image__avatar-wrapper')
			.add({
				'slds-align_absolute-center': !this.hideAvatarBackground || this.avatarAlignment === 'center',
			})
			.toString();
	}
	
	get avatarStyle() {
		let avatarStyle = (this.imageSrc ? `background-image: url(${this.imageSrc});` : '') +
			(this.avatarBorderRadius !== '' ? `border-radius: ${this.avatarBorderRadius};` : '') +
			`height: ${this.avatarSize};` +
			`width: ${this.avatarSize};`;
		return avatarStyle;
	}
	
	get imageStyle() {
		return this.imageSrc ? `background-image: url(${this.imageSrc});` : '';
	}
	
	get imageWrapperStyle() {
		let imageWrapperStyle = `background-size: ${this.imageBackgroundSize};`;
		if ((!this.hideAvatarBackground && this.useAvatar) || this.imageBackgroundColor !== '') {
			imageWrapperStyle += `background-color: ${this.imageBackgroundColor};`;
		}
		
		return imageWrapperStyle;
	}
	
	get showImage() {
		if (this.hideImage || this.hideAvatarBackground) {
			return false;
		}
		return (this.imageSrc && this.imageSrc !== '');
	}
	
	get showPlaceholderImage() {
		if (this.hideImage) {
			return false;
		}
		return (!this.hidePlaceholder && (!this.imageSrc || this.imageSrc === ''));
	}
	


}