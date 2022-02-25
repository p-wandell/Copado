// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
		helper.setIsLiking(component);
	},

	handleLikeClick: function(component, event, helper) {
		if (component.get("v.isLiking")) {
			helper.unLike(component);
		} else {
			helper.like(component);
		}
	}
})