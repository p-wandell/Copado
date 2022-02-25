// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getPicklists: function (component) {
		for (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {
			var customField = component.get('v.customField' + pos);

			if (customField.length) {
				var auraId = 'typeAheadCustomField' + pos;
				this.getEventPicklistValues(component, 'auraId', customField, 'v.customValuesField' + pos, '');
			}
		}
	},

	getEventPicklistValues: function (component, fieldAuraId, fieldName, valueSet, searchString) {
		var action = component.get('c.getEventPickList');

		action.setParams({
			'fieldName'   : fieldName,
			'searchString': searchString
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS') {
				var values = actionResult.getReturnValue();

				if (searchString.length && !values.length) {
					// console.log('Type ahead pickList empty for ' + fieldName);
					this.setInvalidField(component, fieldAuraId);
				}

				values.unshift(component.get('v.selectAll'));
				component.set(valueSet, values);
				// console.log('Picklist (' + fieldName + ')');
				// console.log('    ' + values);
			}
		});

		$A.enqueueAction(action);
	},

	fireSearchEvent: function (component, clearAll) {
		var selectAll    = component.get('v.selectAll');
		var filterString = '';

		for (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {
			var customField = component.get('v.customField'+pos);
			if (customField.length) {
				var customSearch = component.get('v.searchCustomField'+pos);

				if (customSearch.length && customSearch !== selectAll) {
					filterString += customField + ':' + customSearch + ';';
				}
			}
		}

		$A.get("e.c:SVNSUMMITS_Events_Filter_Event")
			.setParams({
				'filterString': filterString
			}).fire();

	}
})