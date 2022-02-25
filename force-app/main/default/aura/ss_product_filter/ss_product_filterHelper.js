/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/21/17.
 */
({
	fireSearchEvent: function(component) {
		let filterEvent  = $A.get("e.c:ss_product_filter_event");

		let searchString = component.get('v.searchProductCode');
		let filterString = component.get('v.searchProductFamily');
		let sortString   = component.get('v.sortOrder');

		if (filterString === $A.get("$Label.c.ss_pc_selectAll")) {
			filterString = '';
		}

		filterEvent.setParams({
			'searchProductCode'  : searchString,
			'searchProductFamily': filterString,
			'sortOrder'          : sortString
		});

		filterEvent.fire();
	}
});