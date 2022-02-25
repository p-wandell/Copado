import {LightningElement, api, track} from 'lwc';
import {classSet} from 'c/x7sShrUtils';

export default class x7sShrCardBody extends LightningElement {
    @api description;
	@api descriptionLines = '0';
	@api title;
	@api titleLines = '0';
	@api topics;
	@api textAlign = 'left';
	@api useHrefOnly = false; // Forces the event handler to only rely on what is entered in the "href" of the anchor link
    @api href = '';
    @api recordId = '';

    handleTitleClick(evt) {
		if (!this.useHrefOnly){
			// Stop the event's default behavior.
			// Stop the event from bubbling up in the DOM.
			evt.preventDefault();
			evt.stopPropagation();
			// Allow the controlling component to handle the event, similar to:
			// <c-x7s-shr-card-horizontal record-id={recordId} ontitleclick={clickHandler}></c-x7s-shr-card-horizontal>
			this.dispatchEvent(new CustomEvent('titleclick', { 
				detail: this.recordId
			}));
		}
	}

    	
	get descriptionClass() {
		return classSet('card__description')
			.add({
				'card_max-lines': this.descriptionLines && this.descriptionLines !== '0'
			})
			.toString();
	}
	
	get descriptionStyle() {
		let style = this.descriptionLines && this.descriptionLines !== '0' ? `-webkit-line-clamp: ${this.descriptionLines};` : '';
		return style;
	}
	
	get titleClass() {
		return classSet('card__title')
			.add({
				'card_max-lines': this.titleLines && this.titleLines !== '0'
			})
			.toString();
	}

    get titleStyle() {
		let style = this.titleLines && this.titleLines !== '0' ? `-webkit-line-clamp: ${this.titleLines};` : '';
		return style;
	}
	
	get showTitle() {
		return this.title && this.title !== '';
	}
}