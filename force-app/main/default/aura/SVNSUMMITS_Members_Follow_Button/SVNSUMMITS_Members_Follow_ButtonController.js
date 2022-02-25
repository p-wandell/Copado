/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 1/5/18.
 */
({
	handleFollowClick: function (component, event, helper) {
		var member      = component.get('v.member');
		var followEvent = $A.get("e.c:SVNSUMMITS_Members_Follow_Event");

		followEvent.setParams({
			'follow'   : !member.isFollowing,
			'recordId' : member.Id
		});

		member.isFollowing = !member.isFollowing;
		component.set('v.member', member);

		followEvent.fire();
	}
});