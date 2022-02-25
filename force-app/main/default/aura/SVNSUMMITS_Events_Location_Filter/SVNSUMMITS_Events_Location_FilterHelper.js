/**
 * Created by francoiskorb on 9/1/17.
 */
({
	getPicklists: function (component) {
		this.getEventPicklistValues(component, 'locationTypeAhead', 'Location_Name__c', 'v.locationValues', '');
	},

	setInvalidField : function (component, fieldId) {
		//let inputField = component.find(fieldAuraId);
		//inputField.set('v.validity', {valid:false, badInput :true});

		$A.util.addClass(component.find(fieldId), 'showInvalid');
	},

	clearInvalidField : function (component, fieldId) {
		//let inputField = component.find(fieldAuraId);
		//inputField.set('v.validity', {valid:true, badInput :false});
		$A.util.removeClass(component.find(fieldId), 'showInvalid');
	},

	getEventPicklistValues: function (component, fieldAuraId, fieldName, valueSet, searchString) {
		let action = component.get('c.getEventsPicklist');

		action.setParams({
			fieldName    : fieldName,
			searchString : searchString
		});

		action.setStorable();

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS') {
				let values = actionResult.getReturnValue();

				if (searchString.length && !values.length) {
					console.log('Type ahead pickList empty for ' + fieldName);
					this.setInvalidField(component, fieldAuraId);
				}

				values.unshift(component.get('v.selectAll'));
				component.set(valueSet, values);
			}
		});

		$A.enqueueAction(action);

	},

	fireSearchEvent: function (component) {
		let locationString = '';
		let selectAll      = component.get('v.selectAll');
		let threshold      = component.get('v.searchThreshold');
		let locationFilter = component.get('v.locationFilter');

		if (locationFilter) {

			if (locationFilter.length >= threshold && locationFilter !== selectAll) {
				locationString = locationFilter;
			}
		}
		
		let locationEvent  = $A.get("e.c:SVNSUMMITS_Events_Location_Filter_Event");

		locationEvent.setParams({
			filterValue : locationString
		});

		locationEvent.fire();
	}

});