/*
 * Copyright (c) 2020. 7Summits Inc.
 */

({
	getURLParam : function() {
		let query = location.search.substr(1);
		let result = [];
		query.split("&").forEach(part => {
			let items = part.split("=");
			if (items.length > 1) {
				result[items[0]] = decodeURIComponent(items[1].replace(/\+/g, "%20"));
			}
		});
		
		return result;
	}
});