/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	getFeaturedMembers: function (component) {
		let action = component.get("c.getFeaturedMembers");
		action.setParams({
			recordNickName1: component.get("v.recordNickName1"),
			recordNickName2: component.get("v.recordNickName2"),
			recordNickName3: component.get("v.recordNickName3"),
			recordNickName4: component.get("v.recordNickName4"),
			recordNickName5: component.get("v.recordNickName5"),
			recordNickName6: component.get("v.recordNickName6"),
			recordNickName7: component.get("v.recordNickName7"),
			recordNickName8: component.get("v.recordNickName8"),
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				let membersListWrapper = response.getReturnValue();

				for (let i = 0; i < membersListWrapper.membersList.length; i++) {
					// am I following this member
					membersListWrapper.membersList[i].isFollowing = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).isFollowing;

					// Store the number of followers to display on the component
					membersListWrapper.membersList[i].intNumberOfFollowers = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intNumberOfFollowers;

					// Store the number of like received to display on the component
					membersListWrapper.membersList[i].intLikeReceived = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intLikeReceived;

					// number of posts made
					membersListWrapper.membersList[i].intPostsMade = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intPostsMade;

					// Store the topics name for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopics = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics;

					// Store the topics name for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopics1 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics1;

					// Store the topics name for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopics2 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics2;

					// Store the topics Id for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopicId = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId;

					// Store the topics Id for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopicId1 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId1;

					// Store the topics Id for displaying on component
					membersListWrapper.membersList[i].strKnowledgeTopicId2 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId2;
				}

				component.set("v.membersListWrapper", membersListWrapper);
			}
		});

		$A.enqueueAction(action);
	},

	initializeSlider: function (component) {
		if (component.get('v.layout') === 'slider') {
			const globalId = component.getGlobalId();
			const items = component.get("v.itemsShown");
			// let sliderX = component.find('_carouselViewer').getElement();

			let carousel = document.getElementById(globalId + '_carouselViewer');

			let settings = {
				item: items,
				slideMove: items,
				useCSS: true,
				cssEasing: 'ease',
				easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
				speed: 600,
			};

			if (carousel) {
				let slider = $(carousel).lightSlider(settings);
				slider.refresh();
				return;
			}

			window.setTimeout(
				$A.getCallback(function () {
					$('.responsive').lightSlider({
						item: items,
						slideMove: items,
						useCSS: true,
						cssEasing: 'ease',
						easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
						speed: 600,
					});
				}), 100
			);
		}
	},

	followRecord : function (component, followAction, recordId) {
		let self   = this;
		let action = component.get(followAction ? 'c.followRecord' : 'c.unfollowRecord');

		action.setParams({
			'recordId' : recordId
		});

		action.setCallback(this, function(response) {
			let state = response.getState();

			if (state !== "SUCCESS") {
				self.showMessage('error', 'Featured - Follow Button', 'Failed to follow selected member');
			}
		});

		$A.enqueueAction(action);
	}
});