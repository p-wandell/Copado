/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by joecallin on 7/18/17.
 */
({
	gotoRecord: function (component, event, helper) {
		helper.gotoRecord(component, component.get('v.productId'));
	}
});