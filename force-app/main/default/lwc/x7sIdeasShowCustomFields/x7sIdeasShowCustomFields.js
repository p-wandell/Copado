/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api} from 'lwc';

export default class X7sIdeasShowCustomFields extends LightningElement {
	
	@api customField;
	@api hideEmptyCustomFields;
	
	get showCustomField() {
		if (this.customField) {
			return !(this.hideEmptyCustomFields && this.customField.value === '');
		}
	}
	
	get notCheckBox() {
		return (this.customField.fieldType !== 'Checkbox');
	}
	
	get Text() {
		return (this.customField.fieldType === 'Text');
	}
	
	get Textarea() {
		return (this.customField.fieldType === 'Textarea');
	}
	
	get Richtext() {
		return (this.customField.fieldType === 'Richtext');
	}
	
	get Date() {
		return (this.customField.fieldType === 'Date');
	}
	
	get DateTime() {
		return (this.customField.fieldType === 'DateTime');
	}
	
	get Currency() {
		return (this.customField.fieldType === 'Currency');
	}
	
	get Number() {
		return (this.customField.fieldType === 'Number');
	}
	
	get Percent() {
		return (this.customField.fieldType === 'Percent');
	}
	
	get Email() {
		return (this.customField.fieldType === 'Email');
	}
	
	get Phone() {
		return (this.customField.fieldType === 'Phone');
	}
	
	get Checkbox() {
		return (this.customField.fieldType === 'Checkbox');
	}
	
	get Picklist() {
		return (this.customField.fieldType === 'Picklist');
	}
}