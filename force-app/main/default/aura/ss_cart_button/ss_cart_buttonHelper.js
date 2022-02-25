/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francoiskorb on 11/15/17.
 */
({
	getOrder: function (component) {
		this.doCallout(component, 'c.getOrder', {'setting': component.get('v.setting')})
			.then($A.getCallback(function (model) {
				component.set('v.model',     model);
				component.set('v.usePoints', model.usePoints);
				component.set('v.itemCount', model.totalItems);
				component.set('v.itemTotal', model.subTotal);
			}));
	}
});