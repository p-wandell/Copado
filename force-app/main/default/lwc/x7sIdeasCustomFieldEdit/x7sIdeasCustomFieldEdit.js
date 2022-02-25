/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

export default class X7SIdeasCustomFieldEdit extends LightningElement {
	@api customField;
	@api customFields;
	dataValues;
	validIdea = true;
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.setCustomFields();
		registerListener('saveclick', this.handleSave, this);
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'validatefield', {validateField: this.validIdea});
	}
	
	disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
	}
	
	handleSave(evt) {
		if (evt.value === false) {
			this.valdateField();
			fireEvent(this.pageRef, 'validatefield', {validateField: this.validIdea});
		}
	}
	
	get RichText() {
		return this.customField.fieldType === 'Richtext';
	}
	
	get Text() {
		return this.customField.fieldType === 'Text';
	}
	
	get Textarea() {
		return this.customField.fieldType === 'Textarea';
	}
	
	get Date() {
		return this.customField.fieldType === 'Date';
	}
	
	get DateTime() {
		return this.customField.fieldType === 'DateTime';
	}
	
	get Currency() {
		return this.customField.fieldType === 'Currency';
	}
	
	get Number() {
		return this.customField.fieldType === 'Number';
	}
	
	get Percent() {
		return this.customField.fieldType === 'Percent';
	}
	
	get Email() {
		return this.customField.fieldType === 'Email';
	}
	
	get Phone() {
		return this.customField.fieldType === 'Phone';
	}
	
	get Checkbox() {
		return this.customField.fieldType === 'Checkbox';
	}
	
	get Picklist() {
		return this.customField.fieldType === 'Picklist';
	}
	
	setCustomFields() {
		if (this.customField) {
			if (this.customField.fieldType === 'Picklist') {
				this.dataValues = this.customField.dataValues.map(item => {
					return {label: item, value: item}
				});
			}
		}
	}
	
	handleChange(evt) {
		this.valdateField();
		let validField = this.validIdea;
		let apiname = evt.currentTarget.dataset.apiname;
		let fieldValue = evt.target.value;
		let fieldType = evt.target.dataset.name;
		if (fieldType === 'checkbox') {
			fieldValue = evt.target.checked;
		}
		
		const customEve = new CustomEvent("customvalues", {
			detail: {
				apiName: apiname,
				fieldValue: fieldValue,
				fieldType: fieldType,
				validField: validField
			}
		});
		this.dispatchEvent(customEve);
	}
	
	valdateField() {
		const customFields = this.customFields;
		
		if (customFields.length > 0) {
			
			const allValid = [...this.template.querySelectorAll("[data-id=ideaCustomInput]")]
				.reduce((validSoFar, inputCmp) => {
					inputCmp.reportValidity();
					return validSoFar && inputCmp.checkValidity();
				}, true);
			
			this.validIdea = allValid;
		}
	}
	
	validateRichTextField(htmlString) {
		return !!htmlString && !!this.getHtmlPlainText(htmlString).trim();
	}
}