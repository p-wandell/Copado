/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesCriteriaFieldModel implements Comparable{
	@AuraEnabled
	public String id { get; set; }
	@AuraEnabled
	public Decimal logicId { get; set; }
	@AuraEnabled
	public String fieldName { get; set; }
	@AuraEnabled
	public String fieldValue { get; set; }
	@AuraEnabled
	public String operator { get; set; }
	@AuraEnabled
	public String type { get; set; }

	public x7sFilesCriteriaFieldModel() {
		id = '';
		logicId = 0;
		fieldName = '';
		fieldValue = '';
		operator = '';
		type = '';
	}

	public Integer compareTo (Object targetItem) {
		Integer returnValue = 0;

		x7sFilesCriteriaFieldModel target = (x7sFilesCriteriaFieldModel)targetItem;

		if (this.logicId > target.logicId) {returnValue = 1; }
		else if (this.logicId < target.logicId) {returnValue = -1;}
		else if (this.logicId == null && target.logicId != null) { returnValue = -1;}
		else if (this.logicId != null && target.logicId == null) {returnValue = 1;}

		return returnValue;
	}

	public void dump(String title) {
		System.debug('x7sFilesCriteriaFieldModel: ' + title);
		System.debug('id: ' + this.id);
		System.debug('logicId:    ' + this.logicId);
		System.debug('fieldName:  ' + this.fieldName);
		System.debug('operator:   ' + this.operator);
		System.debug('fieldValue: ' + this.fieldValue);
		System.debug('fieldType:  ' + this.type);
	}
}