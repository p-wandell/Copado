/**
 * Created by francois korb on 1/15/18.
 */
({
	doInit: function (component, event, helper) {
		helper.doCallout(component, 'c.getPicklistValues',
			{
				objName:   helper.custom.EVENT_OBJ,
				fieldName: helper.events.fields.eventType
			}, true, 'Get Event Types')
			.then($A.getCallback(function (results) {
				var values = results;

				values.unshift(component.get('v.selectAll'));
				component.set('v.eventTypeValues', values);
			}));

	},

	updateFilter: function (component, event, helper) {
		var filterEvent  = $A.get("e.c:SVNSUMMITS_Events_Type_Filter_Event");
		var selectAll    = component.get('v.selectAll');
		var filerValue   = component.get('v.eventType');
		var filterString = '';

		if (filerValue) {
			if (filerValue.length && filerValue !== selectAll) {
				filterString = filerValue;
			}
		}

		filterEvent.setParams({
			'filterValue' : filterString
		});

		filterEvent.fire();
	}
})