/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-04-15.
*/
import {LightningElement, track, api, wire} from 'lwc';

export default class x7SModal extends LightningElement {
    @api customId;
    @api customClass;
    @track showFooter = true;
    @track headerClass = 'slds-modal__header';
    @track checked = false;
    renderedCallback() {
        if(!this.checked){
            this.headerClass += this.querySelectorAll('[slot=\'header\']').length === 0 ? ' slds-modal__header_empty' : '';
            this.showFooter = this.querySelectorAll('[slot=\'footer\']').length > 0;
            this.checked = true;
        }
    }
    closeModal(){
        this.dispatchEvent(new CustomEvent('close'));
    }
}