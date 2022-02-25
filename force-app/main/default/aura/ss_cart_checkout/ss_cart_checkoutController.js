/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/9/17.
 */
({

	init: function (component, event, helper) {
		helper.doCallout(component, 'c.getOrder', {'setting': component.get('v.setting')}
		).then($A.getCallback(function (model) {
			component.set('v.model', model);
			component.set('v.usePoints', model.usePoints);
			component.set('v.itemCount', model.items.length);
			component.set('v.itemTotal', model.subTotal);
		}));
	},

	goBack: function (component, event, helper) {
		window.history.back();
	}
});