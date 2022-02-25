/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/3/17.
 */
({
	gotoRecord: function (component, event, helper) {
		helper.gotoRecord(component, component.get('v.product').productId);
	}
});