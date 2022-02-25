/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesCriteriaListModel {
	@AuraEnabled
	public String id { get; set; }
	@AuraEnabled
	public String defaultLogic { get; set; }
	@AuraEnabled
	public String customLogic { get; set; }
	@AuraEnabled
	public List<x7sFilesCriteriaFieldModel> criteriaFieldList { get; set; }

	public x7sFilesCriteriaListModel() {
		this.defaultLogic = 'AND';
		this.customLogic = '';
		this.criteriaFieldList = new List<x7sFilesCriteriaFieldModel>();
	}

	public x7sFilesCriteriaFieldModel findByLogicId(String targetId) {
		Decimal logicTarget = Decimal.valueOf(targetId);
		System.debug('findByLogicId: ' + logicTarget);

		for (x7sFilesCriteriaFieldModel entry : criteriaFieldList) {
			System.debug('entry: ' + entry.logicId);
			if (entry.logicId == logicTarget) {
				return entry;
			}
		}
		return null;
	}

	public void dump(String title) {
		System.debug('x7sFilesCriteriaListModel ' + title);
		System.debug('Entries       : ' + this.criteriaFieldList.size());
		System.debug('id            : ' + this.id);
		System.debug('defaultLogic  : ' + this.defaultLogic);
		System.debug('shareLogic    : ' + this.customLogic);

		Integer pos = 0;
		for (x7sFilesCriteriaFieldModel entry : criteriaFieldList) {
			entry.dump(String.valueOf(pos));
			++pos;
		}
	}
}