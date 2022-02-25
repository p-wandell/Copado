/*
 * Copyright (c) 2020. 7Summits Inc.
 */

({
	doInit: function (component, event, helper) {
		const lexRecordId = 'c__ideaId';
		
		let recordId = component.get('v.recordId');
		
		if (!recordId) {
			let search = helper.getURLParam();
			if (search && search[lexRecordId]) {
				recordId = search[lexRecordId];
			}
			if (recordId) {
				component.set('v.recordId', recordId);
			}
		}
		
		if (component.get('v.recordId')) {
			let action = component.get("c.getExtensionId");
			action.setParams({ideaId: component.get('v.recordId')});
			action.setCallback(this, function (actionResult) {
				if (actionResult.getState() === 'SUCCESS') {
					let _resp = actionResult.getReturnValue();
					console.log('RESP: ' + JSON.stringify(_resp));
					component.set('v.idea', _resp);
				}
			});
			$A.enqueueAction(action);
		}
	}
});