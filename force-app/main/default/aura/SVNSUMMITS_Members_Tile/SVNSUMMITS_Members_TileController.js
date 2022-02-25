/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	goToRecord: function (component, event, helper) {
		helper.gotoRecord(component, event.currentTarget.dataset.id);
	}
})