/*
 * Copyright (c) 2018. 7Summits Inc.
 */
({
	doInit: function (component, event, helper) {
		var tileSize = '12'; // rows
		var layout   = component.get('v.listLayout');

		//if (layout === helper.layout.TILE) {
			var tiles = component.get('v.numberOfTiles');

			switch (tiles) {
				case '1' :
					tileSize = '10';
					break;
				case '2' :
					tileSize = '6';
					break;
				case '5' :
					tileSize = '2';
					break;
				default:
					tileSize = '4';
					break;
			}
		//}

		component.set('v.layoutTile', layout === helper.layout.TILE);
		component.set('v.tileSize',   tileSize);

		if (component.get('v.initialLoad')) {
			helper.setListFilters(component);
			helper.getMemberList(component, event, 1);
		} else {
			helper.hideSpinner(component);
		}
	},

	handleLayoutButtons: function(component, event, helper) {
		var selectedLayout = event.getSource().getLocalId();
		var currentLayout  = component.get('v.listLayout');

		if (selectedLayout !== currentLayout) {
			component.set('v.listLayout',
				selectedLayout === helper.layout.TILE ?
					helper.layout.TILE :
					helper.layout.LIST);
			component.set('v.layoutTile',
				selectedLayout === helper.layout.TILE);
		}
	},

	getNextPage: function (component, event, helper) {
		var model       = component.get('v.membersListWrapper');
		var currentPage = model !== null ? model.pageNumber + 1 : 1;

		helper.debug(component, 'Next Page getMemberList for page ' + currentPage);
		component.set("v.membersListWrapper.membersList", null);

		helper.getMemberList(component, event, currentPage);
	},

	getPreviousPage: function (component, event, helper) {
		var model       = component.get('v.membersListWrapper');
		var currentPage = model !== null ? model.pageNumber - 1 : 1;

		helper.debug(component, 'Prev Page getMemberList for page ' + currentPage);
		component.set("v.membersListWrapper.membersList", null);
		
		helper.getMemberList(component, event, currentPage);
	},

	setSortBy: function (component, event, helper) {
		helper.debug(component, "sort by method called", null);

		var sortBy = event.getParam("sortBy");
		component.set("v.sortBy", sortBy);
		helper.getMemberList(component, event, 1);
	},

	setMembersFilters: function (component, event, helper) {
		helper.debug(component, "members filter called", null);

		var searchMyMembers = event.getParam("searchMyMembers");
		var searchString    = event.getParam("searchString");
		var topicSearch     = event.getParam("topicString");
		var clearAll        = event.getParam("clearAll");

		component.set("v.searchString",    searchString);
		component.set("v.searchMyMembers", searchMyMembers);
		component.set('v.topicString',     topicSearch);

		var search = searchString.replace(';', '').replace(':', '').trim();

		if (!component.get('v.initialLoad') &&
			(clearAll || (search.length === 0 && searchMyMembers.length === 0 && topicSearch.length === 0))) {
			helper.clearMemberList(component);
		} else {
			helper.getMemberList(component, event, 1);
		}
	},

	handleFollowRecord: function (component, event, helper) {
		helper.debug(component, "follow event handled");
		helper.showSpinner(component);

		let followAction = event.getParam("follow");
		let followRecord = event.getParam("recordId");
		let model        = component.get('v.membersListWrapper');
		let currentPage  = model !== null ? model.pageNumber : 1;

		helper.followRecord(component, followAction, followRecord, currentPage);
		helper.hideSpinner(component);
	}
});