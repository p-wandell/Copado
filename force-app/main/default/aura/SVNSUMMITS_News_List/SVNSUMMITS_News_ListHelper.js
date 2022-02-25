// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getNewsList: function (component) {
		this.showSpinner(component);
		let self = this;
		this.debug(component, "Fetch News Called..", null);
		component.set("v.strError", null);

		const groupId = component.get("v.groupID");
		if (groupId !== '') {
			component.set('v.topicName', groupId);
		}

		const action = component.get("c.getNews");
		action.setParams(this.getParams(component));

		action.setCallback(this, function (response) {
			let state = response.getState();
			self.hideSpinner(component);

			if (component.isValid() && state === "SUCCESS") {
				let newsListWrapper = self.parseNewsNameSpace(component, response.getReturnValue());

				//updated to catch exception if any occurred in apex
				if (newsListWrapper.field !== '' && newsListWrapper.field !== null) {
					if (newsListWrapper.field === 'Date') {
						self.debug(component, "Exception occurred", newsListWrapper.errorMsg);

						if (newsListWrapper.errorMsg !== '' && newsListWrapper.errorMsg !== null) {
							if (newsListWrapper.errorMsg === 'List index out of bounds: 1') {
								component.set("v.strError", 'Invalid Date.');
							} else {
								component.set("v.strError", 'Unexpected Error Occured, Please contact your Administrator.');
							}
						}
					} else {
						self.debug(component, "Exception occured", newsListWrapper.errorMsg);
						if (newsListWrapper.errorMsg !== '' && newsListWrapper.errorMsg !== null)
							component.set("v.strError", 'Unexpected Error Occured, Please contact your Administrator.');
					}
				}

				//updated code to hide recommended component if no records found
				if (component.get("v.displayMode") === 'Compact') {
					if (newsListWrapper.newsList.length === 0) {

						self.debug(component, "No records to display in list - Hide()");
						$('.CCNEWSLCSVNSUMMITS_News_List').hide();
					}
				}

				const appEvent = $A.get("e.c:SVNSUMMITS_News_Header_Event");
				appEvent.setParams({
					"totalResults": newsListWrapper.totalResults,
				});
				appEvent.fire();

				component.set("v.totalNews", newsListWrapper.totalResults);
				component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));

				//show no items found
				if (newsListWrapper.totalResults === 0) {
					$A.util.removeClass(component.find('noItems'), 'slds-hide');
				}
			}
		});
		$A.enqueueAction(action);
	},

	getParams: function(component) {
		return {
			numberOfNewsPerPage: component.get("v.numberOfNewsPerPage"),
			strRecordId: component.get("v.filterId"),
			networkIds: component.get('v.networkIds'),
			sortBy: component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			filterByAuthor: component.get("v.filterByAuthor"),
			topicName: component.get("v.topicName"),
			filterOn: component.get("v.filterOn"),
			searchTerm: component.get("v.searchstr"),
			fromDate: component.get("v.fromDate"),
			toDate: component.get("v.toDate"),
		};
	},

	getNextPage: function (component) {
		let self = this;
		this.debug(component, "Next Page Clicked...", null);

		const action = component.get("c.nextPage");
		let   params = this.getParams(component);
		params['pageNumber'] = component.get("v.newsListWrapper").pageNumber;
		action.setParams(params);

		action.setCallback(this, function (actionResult) {
			let newsListWrapper = self.parseNewsNameSpace(component, actionResult.getReturnValue());

			component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));
			let pageNumberComp = self.component.find("pageNumber");
			pageNumberComp.set("v.value", newsListWrapper.pageNumber);

		});

		$A.enqueueAction(action);
	},

	getPreviousPage: function (component) {
		let self = this;
		this.debug(component, "Previous Page Clicked...", null);

		const action = component.get("c.previousPage");
		let   params = this.getParams(component);
		params['pageNumber'] = component.get("v.newsListWrapper").pageNumber;
		action.setParams(params);

		action.setCallback(this, function (actionResult) {
			let newsListWrapper = self.parseNewsNameSpace(component, actionResult.getReturnValue());

			component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));

			let pageNumberComp = self.component.find("pageNumber");
			pageNumberComp.set("v.value", newsListWrapper.pageNumber);

		});

		$A.enqueueAction(action);
	},

	parseNewsNameSpace: function (component, newsListWrapper) {
		let wrapper = this.parseNamespace(component, newsListWrapper);
		wrapper.newsList = this.parseNamespace(component, wrapper.newsList);

		return wrapper;
	},

	updateNewsWrapper: function (component, newsListWrapper) {
		const nameSpace = component.get('v.nameSpace');

		for (let i = 0; i < newsListWrapper.newsList.length; i++) {
			newsListWrapper.newsList[i].commentCount = newsListWrapper.newsToCommentCountMap[newsListWrapper.newsList[i].Id];
			if (newsListWrapper.likedNewsIds) {
				newsListWrapper.newsList[i].isLiking = newsListWrapper.likedNewsIds.includes(newsListWrapper.newsList[i].Id);
			}
			newsListWrapper.newsList[i].strTime = moment(newsListWrapper.newsList[i][nameSpace + 'Publish_DateTime__c']).fromNow();

			// if (newsListWrapper.newsList[i].Name.length > 70) {
			// 	newsListWrapper.newsList[i].Name = newsListWrapper.newsList[i].Name.substring(0, 70);
			// }

			newsListWrapper.newsList[i].topics1 = [];
			newsListWrapper.newsList[i].topics1.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
			newsListWrapper.newsList[i].topics = [];
			newsListWrapper.newsList[i].groupName = newsListWrapper.groupIdToName[newsListWrapper.newsList[i][nameSpace + 'GroupId__c']];

			/* Logic for topics will be displayed till 27 characters only */
			if (newsListWrapper.newsList[i].topics1 !== undefined) {
				for (let j = 0; j < newsListWrapper.newsList[i].topics1.length; j++) {
					if (newsListWrapper.newsList[i].topics1[j] !== undefined) {
						for (let jj = 0; jj < newsListWrapper.newsList[i].topics1[j].length; jj++) {
							if (newsListWrapper.newsList[i].topics !== undefined) {
								newsListWrapper.newsList[i].topics.push(newsListWrapper.newsList[i].topics1[j][jj]);
							}
						}
					}
				}
			}
		}
		return newsListWrapper;
	},

	get_SitePrefix: function (component) {
		const action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			let sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);

			// remove the trailing /s for the image
			if (sitePath[sitePath.length-1] === 's') {
				component.set("v.sitePrefix", sitePath.substring(0, sitePath.length-2));
			} else {
				component.set("v.sitePrefix", sitePath.replace("/s", "/"));
			}
		});

		$A.enqueueAction(action);
	},

	isNicknameDisplayEnabled: function (component) {
		const action = component.get("c.isNicknameDisplayEnabled");
		action.setCallback(this, function (actionResult) {
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
			this.debug(component, "Nick Name for Community Boolean : ", component.get("v.isNicknameDisplayEnabled"));
		});
		$A.enqueueAction(action);
	},

	sortByShowHide: function () {

		$(window).click(function () {
			$('#dropDwnBtn_menu').hide();
		})

		$('#dropDwnBtn').click(function (even) {
			even.stopPropagation();
		})

		$('#dropDwnBtn').click(function () {
			$('#dropDwnBtn_menu').toggle();
		});

		$('#dropDwnBtn_menu').click(function () {
			if ($('#dropDwnBtn_menu').show()) {
				$('#dropDwnBtn_menu').hide();
			} else {
				$('#dropDwnBtn_menu').show();
			}
		});
	},

	showSpinner: function (component) {
		console.log('Spinner on...');
		$A.util.removeClass(component.find('listSpinner'), 'slds-hide');
	},

	hideSpinner: function (component) {
		console.log('Spinner off...');
		$A.util.addClass(component.find('listSpinner'), 'slds-hide');
	}

});