// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    handleTileLikeClick: function(component, event, helper){
	    var recordId = component.get("v.newsTileId");

		if (component.get("v.isLiking")) {
			helper.unLike(component, recordId);
		} else {
			helper.like(component, recordId);
		}
    }
})