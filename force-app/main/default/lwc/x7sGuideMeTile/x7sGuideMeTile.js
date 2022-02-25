/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';

export default class x7sGuideMeTile extends LightningElement {
    @api modalSize = 'Large - 390px';
    @api largeModal = false;
    @api smallModal = false;
    @api mobileModal = false;
    @api layoutOne = false;
    @api layoutTwo = false;
    @api layoutThree = false;
    @api hasNPages = false;
    @api hasFieldApiName = false;
    @api showAgainMessage ='';
    @api isChecked = false;
    @api imageSrc = '';
    @api borderOn = false;
    @api borderOnElement = false;
    @api title = '';
    @api leftAlign = false;
    @api description = '';

    handleModalSize() {
        if(this.modalSize === "Small - 390px") {
            this.smallModal = true;
            this.largeModal = false;
            this.mobileModal = false;
        }
        if(this.modalSize === "Large - 600px") {
            this.largeModal = true;
            this.smallModal = false;
            this.mobileModal = false;
        }
        if(this.modalSize === "Mobile") {
            this.mobileModal = true;
            this.smallModal = false;
            this.largeModal = false;
        }
    }
    handleValue(event) {
        this.isChecked = event.target.checked;
        //console.log('Checked:: ' + this.isChecked);

        const selectedEvent = new CustomEvent("progressvaluechange", {
            detail : this.isChecked
        });
        this.dispatchEvent(selectedEvent);
    }
    connectedCallback() {
        this.handleModalSize();
    }
}