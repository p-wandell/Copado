/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 1/2/18.
 */
({
	goToRecord: function (component, event, helper) {
		helper.gotoRecord(component, event.currentTarget.dataset.id);
	}
})