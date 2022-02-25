// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	toggleMembership : function (component) {
		let userId   = component.get('v.wrapperGroupsObj.currentUserId')
		let group    = component.get('v.group');
		let isMember = group.isMember;
		let action   = isMember ? component.get('c.leaveGroup') : component.get('c.joinGroup');

		action.setParams({
			'groupId': group.Id,
			'userId': userId
		});

		action.setCallback(this, function (actionResult) {
			let state = actionResult.getState();

			if (state === "SUCCESS") {
				$A.get('e.c:SVNSUMMITS_Groups_Load_Event').fire();
			}
		});

		$A.enqueueAction(action);
	}
});