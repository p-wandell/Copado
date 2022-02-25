// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getNewsRecord: function (component) {
		let self = this;
		let recordId = component.get("v.recordId");
		this.debug(component, 'Posted By called for ', recordId);

		let action = component.get("c.getNewsRecord");
		action.setParams({
			newsRecordId: recordId
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				self.debug(component, 'Posted By Success...', response.getReturnValue());

				//var newsListWrapper = response.getReturnValue();
				let newsListWrapper = this.parseNamespace(component, response.getReturnValue());
				self.debug(component, 'newsListWrapper', newsListWrapper);

				if (newsListWrapper !== null && newsListWrapper.netMem !== null && newsListWrapper.netMem.CreatedDate !== null) {
					component.set("v.strDate", moment(newsListWrapper.netMem.CreatedDate).format('LL'));
				}

				component.set("v.newsListWrapper", newsListWrapper);
			}
			else {
				self.debug(component, 'Action getNewsRecord failed...', response);
			}
		});

		$A.enqueueAction(action);
	},

	getIsNickNameEnabled : function (component) {
		let self = this;
		let action = component.get("c.isNicknameDisplayEnabled");

		action.setCallback(this, function (actionResult) {
			self.debug(component, 'Success - isNicknameDisplayEnabled...', actionResult.getReturnValue());
			self.debug(component, '           Show Nickname...' + component.get('v.showNickName'));
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	get_SitePrefix: function (component) {
		let action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			let sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
			//component.set("v.sitePrefix", sitePath.replace("/s",""));
		});
		$A.enqueueAction(action);
	}
});