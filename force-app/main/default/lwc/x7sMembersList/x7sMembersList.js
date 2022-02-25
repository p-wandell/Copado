/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {api, LightningElement, track, wire} from 'lwc';
import {registerListener, unregisterAllListeners, fireEvent} from "c/x7sShrUtils";
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {contact, custom} from "c/x7sMembersBase";

import getMemberListC from "@salesforce/apex/x7sMembersController.getMemberListC";
import getFeaturedMembersLwc from "@salesforce/apex/x7sMembersController.getFeaturedMembersLwc";
import getMetaDataMemberList from "@salesforce/apex/x7sMembersController.getMetaDataMemberList";

import labelButtonFollow from "@salesforce/label/c.x7sMembersButtonFollow";
import labelButtonFollowing from "@salesforce/label/c.x7sMembersButtonFollowing";
import labelButtonUnfollow from "@salesforce/label/c.x7sMembersButtonUnFollow";
import labelKnowledgeableAbout from "@salesforce/label/c.x7sMembersKnowledgeableAbout";
import labelLikes from "@salesforce/label/c.x7sMembersLabelLikes";
import labelPosts from "@salesforce/label/c.x7sMembersLabelPosts";
import labelFollowers from "@salesforce/label/c.x7sMembersLabelFollowers";

export default class X7sMembersList extends NavigationMixin(LightningElement) {
	
	//Options
	@api showjoinbutton = false;
	@api showAvatar = false;
	@api showImages = "true";
	@api listId = "ID_1";
	@api customClass = '';
	@api featureOption;
	@api featureMemberList;
	@api listofMemberIds = [];
	@api numberOfMembers;
	@api variant;
	@api textAlignment;
	@api titleTextSize;
	
	@api displayTitle = "true";
	@api displayPhone = "true";
	@api clickToCall = "false";
	@api displayEmail = "true";
	@api displayKnowledge = "true";
	@api displayFollowButton = "true";
	@api displayChatterStats = "true";
	@api hideInternal = "false";
	@api excludedMembers;
	@api initialLoad = "true";
	@api showTheme = "false";
	
	//- CUSTOM FIELDS
	@api  customLabel1 = '';
	@api  customField1 = '';
	@api  customLabel2 = '';
	@api  customField2 = '';
	@api  customLabel3 = '';
	@api  customField3 = '';
	@api  customLabel4 = '';
	@api  customField4 = '';
	@api  customLabel5 = '';
	@api  customField5 = '';
	@api  customLabel6 = '';
	@api  customField6 = '';
	
	//DATA
	@api  tileSize;
	@api  layoutTile;
	@api  sortBy = '';
	@api  defaultSortBy = '';
	@api  searchMyMembers;
	@api  searchString = '';
	@api  topicString;
	
	//FILTERS
	@api  titleSearchValue = '';
	@api  countryFilter = '';
	@api  stateFilter = '';
	@api  cityFilter = '';
	@api  accountFilter = '';
	@api  topicFilter = '';
	
	@api  customFilter1 = '';
	@api  customValue1 = '';
	@api  customFilter2 = '';
	@api  customValue2 = '';
	@api  customFilter3 = '';
	@api  customValue3 = '';
	@api  customFilter4 = '';
	@api  customValue4 = '';
	@api  customFilter5 = '';
	@api  customValue5 = '';
	@api  customFilter6 = '';
	@api  customValue6 = '';
	
	@track membersListWrapper = [];
	@track error;
	
	@api layout = 'vertical'; // vertical, horizontal	
	@track useAvatar = true;
	
	//from Wrapper
	@track pageNumber = 1;
	@track totalResults;
	@track totalPages;
	@track hasPreviousSet;
	@track hasNextSet;
	@track indvRowId = [];
	
	// Tile styles
	styleVertical = 'slds-text-body_small slds-text-align_center';
	styleHorizontal = 'slds-text-body_small';
	layoutClass = 'slds-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_4-of-12';
	listViewClass = 'slds-size_12-of-12';
	isloading = true;
	
	@wire(CurrentPageReference) pageRef;
	
	labels = {
		labelButtonFollow,
		labelButtonFollowing,
		labelButtonUnfollow,
		labelKnowledgeableAbout,
		labelFollowers,
		labelLikes,
		labelPosts
	};

	connectedCallback() {
		if (this.featureOption === "User Nickname List") {
			if (this.featureMemberList.length) {
				let listNickNames = this.featureMemberList.split(/[ ,]+/).filter(Boolean);
				getFeaturedMembersLwc({listNickNames: listNickNames, isFeature: false})
					.then(result => {
						this.updateMembersList(result.membersList);
					})
					.catch(error => {
						this.error = error;
					});
			}
		}
		if (this.featureOption === "User Record Featured Checkbox") {
			let featureOption = true;
			getFeaturedMembersLwc({isFeature: featureOption})
				.then(result => {
					this.updateMembersList(result.membersList);
				})
				.catch(error => {
					this.error = error;
				});
			
		}
		
		if (this.featureOption === "User ID List") {
			if (this.featureMemberList.length) {
				let memberListItems = this.featureMemberList.split(/[ ,]+/).filter(Boolean);
				this.listofMemberIds = memberListItems.filter(item =>
					item.startsWith(custom.USER_PREFIX) && (item.length === 18 || item.length === 15)
				);
				
				if (this.listofMemberIds && this.listofMemberIds.length) {
					this.setListFilters();
					this.getMemberList(this.pageNumber);
				}
				//console.log('-----User ID List----' + this.listofMemberIds);
			}
		}
		
		if (this.initialLoad && (this.featureOption === "None" ||
			(this.featureOption === "Custom Metadata" && this.featureMemberList.length === 0))) {
			this.setListFilters();
			this.getMemberList(this.pageNumber);
		}
		
		if (this.featureOption === "Custom Metadata") {
			getMetaDataMemberList({recordLabel: this.featureMemberList})
				.then(result => {
					this.listofMemberIds = result.split(/[ ,]+/).filter(Boolean);
					if (this.listofMemberIds && this.listofMemberIds.length) {
						this.setListFilters();
						this.getMemberList(this.pageNumber);
					}
				})
				.catch(error => {
					this.listofMemberIds = undefined;
					this.error = error;
				});
		}
		
		registerListener("memberfilterevent", this.setMembersFilters, this);
		registerListener("cardviewoption", this.cardHandle, this);
		registerListener("listviewoption", this.listHandle, this);
		registerListener("sortbyevent", this.setSortBy, this);
		registerListener("defaultsortbyevent", this.setDefaultSortBy, this);
		registerListener("pageprevious", this.getPreviousPage, this);
		registerListener("pagenext", this.getNextPage, this);
		registerListener("searchstring", this.handleSearch, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, "totalmembers", {id: this.listId, value: this.membersListWrapper.totalResults});
		fireEvent(this.pageRef, 'listhasnext', {id: this.listId, value: this.membersListWrapper.hasNextSet});
		fireEvent(this.pageRef, 'listhasprevious', {id: this.listId, value: this.membersListWrapper.hasPreviousSet});
		fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.membersListWrapper.pageNumber});
		fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.membersListWrapper.totalPages});
		fireEvent(this.pageRef, 'listdefaultview', {id: this.listId, value: this.layout});
	}
	
	get componentClass() {
		return 'x7s-members-list ' + this.showTheme ? `${this.customClass} slds-theme_default` : `${this.customClass}`;
	}
	
	get viewSelectorStyle() {
		return (this.layout !== 'horizontal') ? `${this.layoutClass}` : `${this.listViewClass}`;
	}
	
	get cardTextAlign() {
		return this.layout === 'vertical' ? 'center' : 'left';
	}
	
	get chkCustomFieldLength1() {
		return (this.customField1);
	}
	
	get chkCustomFieldLength2() {
		return (this.customField2);
	}
	
	get chkCustomFieldLength3() {
		return (this.customField3);
	}
	
	get chkCustomFieldLength4() {
		return (this.customField4);
	}
	
	get chkCustomFieldLength5() {
		return (this.customField5);
	}
	
	get chkCustomFieldLength6() {
		return (this.customField6);
	}
	
	cardHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'vertical'; // vertical, horizontal
		}
	}
	
	listHandle(evt) {
		if (this.listId === evt.id) {
			this.layout = 'horizontal'; // vertical, horizontal
		}
	}
	
	handleSearch(evt) {
		if (this.listId === evt.id) {
			this.isloading = true;
			this.searchstring = evt.value;
		}
	}
	
	updateMembersList(membersList) {
		this.listofMemberIds = membersList.map(item => item.Id);
		
		if (this.listofMemberIds && this.listofMemberIds.length) {
			this.setListFilters();
			this.getMemberList(this.pageNumber);
		}
	}
	
	getMemberList(currentPage) {
		this.isloading = true;
		
		let excludedList = this.getExcludedIDs();
		let customFieldList = this.getCustomFieldList();
		
		let params = {
			pageSize: this.numberOfMembers,
			currentPage: currentPage,
			sortBy: this.sortBy,
			searchMyMembers: this.searchMyMembers,
			searchString: (this.searchString) || '',
			topicId: this.topicString,
			hideInternal: this.hideInternal,
			excludeList: excludedList,
			customFields: customFieldList,
			featureIds: this.listofMemberIds
		};
		
		getMemberListC(params)
			.then(result => {
				this.isloading = false;
				let updatedWrapper = this.updateMemberList(result);
				
				console.log('====page number====' + this.membersListWrapper.pageNumber);
				
				this.updateHeader(updatedWrapper.totalResults);
				this.membersListWrapper = updatedWrapper;
				
				console.log('---membersListWrapper--' + JSON.stringify(this.membersListWrapper));
			})
			.catch(error => {
				this.processError(error);
				this.isloading = false;
			});
	}
	
	updateListFollowRecord(recordId, follow) {
		let members = this.membersListWrapper.membersList.filter(member => member.Id === recordId);
		if (members) {
			members[0].isFollowing = follow;
		}
	}
	
	setCustomFields(membersListWrapper, index) {
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			if (customField && customField.length) {
				let fieldSet = true;
				let fieldParts = customField.split('.');
				let fieldValue = membersListWrapper.membersList[index];
				
				for (let part = 0; part < fieldParts.length; part++) {
					if (fieldValue[fieldParts[part]]) {
						fieldValue = fieldValue[fieldParts[part]];
					} else {
						fieldSet = false;
						break;
					}
				}
				
				membersListWrapper.membersList[index][`customField${pos}`] = fieldSet ? fieldValue : '';
			}
		}
	}
	
	clearMemberList() {
		this.isloading = true;
		let membersListWrapper = this.membersListWrapper;
		
		membersListWrapper.membersList = [];
		membersListWrapper.totalResults = 0;
		membersListWrapper.pageNumber = 0;
		membersListWrapper.totalPages = 0;
		membersListWrapper.hasNextSet = false;
		membersListWrapper.hasPreviousSet = false;
		
		this.membersListWrapper = membersListWrapper;
		this.updateHeader(membersListWrapper.totalResults);
	}
	
	updateMemberList(membersListWrapper) {
		for (let i = 0; i < membersListWrapper.membersList.length; i++) {
			
			// am I following this member
			membersListWrapper.membersList[i].isFollowing = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).isFollowing;
			
			let isMember = membersListWrapper.membersList[i].Id;
			let currentUser = membersListWrapper.currentUser;
			membersListWrapper.membersList[i].showJoinButton = (this.displayFollowButton) && (currentUser !== isMember);
			
			membersListWrapper.membersList[i].intNumberOfFollowers = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intNumberOfFollowers;
			
			membersListWrapper.membersList[i].intLikeReceived = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intLikeReceived;
			
			membersListWrapper.membersList[i].intPostsMade = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).intPostsMade;
			
			// Store the topics for displaying on component
			membersListWrapper.membersList[i].strKnowledgeTopics = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics;
			membersListWrapper.membersList[i].strKnowledgeTopics1 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics1;
			membersListWrapper.membersList[i].strKnowledgeTopics2 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopics2;
			
			// Store the topics Id for displaying on component
			membersListWrapper.membersList[i].strKnowledgeTopicId = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId;
			membersListWrapper.membersList[i].strKnowledgeTopicId1 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId1;
			membersListWrapper.membersList[i].strKnowledgeTopicId2 = (membersListWrapper.mapUserId_Wrapper[membersListWrapper.membersList[i].Id]).strKnowledgeTopicId2;
			
			//showTitle Validation
			let title = membersListWrapper.membersList[i].Title;
			let isInternal = membersListWrapper.isInternalUser;
			let isExternal = membersListWrapper.isExternalUser;
			let isGuest = membersListWrapper.isGuestUser;
			let toExternalUser = membersListWrapper.membersList[i].UserPreferencesShowTitleToExternalUsers;
			let toGuestUser = membersListWrapper.membersList[i].UserPreferencesShowTitleToGuestUsers;
			membersListWrapper.membersList[i].showTitle = (title
				&& (isInternal || (isExternal && toExternalUser) || (isGuest && toGuestUser)));
			
			//showPhone Validation
			let phone = membersListWrapper.membersList[i].Phone;
			let toExternalUserPhone = membersListWrapper.membersList[i].UserPreferencesShowMobilePhoneToExternalUsers;
			let toGuestUserPhone = membersListWrapper.membersList[i].UserPreferencesShowMobilePhoneToGuestUsers;
			membersListWrapper.membersList[i].showPhone = (phone
				&& (isInternal || (isExternal && toExternalUserPhone) || (isGuest && toGuestUserPhone)));
			
			//showEmail Validation
			let email = membersListWrapper.membersList[i].Email;
			let toExternalUserEmail = membersListWrapper.membersList[i].UserPreferencesShowEmailToExternalUsers;
			let toGuestUserEmail = membersListWrapper.membersList[i].UserPreferencesShowEmailToGuestUsers;
			membersListWrapper.membersList[i].showEmail = (email
				&& (isInternal || (isExternal && toExternalUserEmail) || (isGuest && toGuestUserEmail)));
			
			this.setCustomFields(membersListWrapper, i);
		}
		
		return membersListWrapper;
	}
	
	setListFilters() {
		// set initial list filters
		let searchString = ':;';
		let topicString = '';
		
		if (this.titleSearchValue && this.titleSearchValue.length) {
			searchString += contact.fields.title + ':' + this.titleSearchValue + ';';
		}
		
		if (this.countryFilter && this.countryFilter.length) {
			searchString += contact.fields.country + ':' + this.countryFilter + ';';
		}
		
		if (this.stateFilter && this.stateFilter.length) {
			searchString += contact.fields.state + ':' + this.stateFilter + ';';
		}
		
		if (this.cityFilter && this.cityFilter.length) {
			searchString += contact.fields.city + ':' + this.cityFilter + ';';
		}
		
		if (this.accountFilter && this.accountFilter.length) {
			searchString += contact.fields.account + ':' + this.accountFilter + ';';
		}
		
		if (this.topicFilter && this.topicFilter.length) {
			topicString = this.topicFilter;
		}
		
		// Custom fields
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customFilter = this[`customFilter${pos}`];
			
			if (customFilter && customFilter.length) {
				let customValue = this[`customValue${pos}`];
				
				if (customValue && customValue.length) {
					searchString += customFilter + ':' + customValue + ';';
				}
			}
		}
		
		this.searchString = searchString;
		this.topicString = topicString;
	}
	
	getExcludedIDs() {
		let idList = [];
		let splitChar = ',';
		let excludedIds = this.excludedMembers;
		
		if (excludedIds && excludedIds.indexOf(splitChar) !== -1) {
			let ids = excludedIds.split(splitChar);
			for (let pos = 0; pos < ids.length; ++pos) {
				if (ids[pos].length > 0) {
					idList.push(ids[pos]);
				}
			}
		} else {
			idList.push(excludedIds);
		}
		
		return idList;
	}
	
	getCustomFieldList() {
		let customFieldList = [];
		
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			
			if (customField) {
				customFieldList.push(customField);
			}
		}
		
		return customFieldList;
	}
	
	setDefaultSortBy(event) {
		this.defaultSortBy = event.value;
		
		if (this.sortBy.length === 0) {
			this.sortBy = this.defaultSortBy;
			this.getMemberList(this.pageNumber);
		}
	}
	
	setSortBy(event) {
		console.log("sort by method called", null);
		this.sortBy = event.value;
		// When the sort by field is changed, always reset back to page 1.
		this.getMemberList(1);
	}
	
	updateHeader(totalResults) {
		let totalMembers = (totalResults === -1) ? '' : totalResults;
		fireEvent(this.pageRef, "total members", {id: this.listId, value: totalMembers});
	}
	
	getNextPage(event) {
		if (this.listId === event.id) {
			this.pageNumber = this.membersListWrapper !== null ? this.membersListWrapper.pageNumber + 1 : 1;
			
			console.log('---getNextPage   current page ===-' + this.pageNumber);
			this.membersListWrapper.membersList = [];
			
			this.getMemberList(this.pageNumber);
		}
	}
	
	getPreviousPage(event) {
		if (this.listId === event.id) {
			this.pageNumber = this.membersListWrapper !== null ? this.membersListWrapper.pageNumber - 1 : 1;
			
			console.log('---getPreviousPage   current page ===-' + this.pageNumber);
			this.membersListWrapper.membersList = [];
			
			this.getMemberList(this.pageNumber);
		}
	}
	
	setMembersFilters(event) {
		if (this.listId === event.id) {
			
			let searchMyMembers = event.searchMyMembers;
			let searchString = event.searchString;
			let topicSearch = event.topicString;
			let clearAll = event.clearAll;
			
			this.searchString = searchString;
			this.searchMyMembers = searchMyMembers;
			this.topicString = topicSearch;
			
			let search = searchString.replace(';', '').replace(':', '').trim();
			
			if (!this.initialLoad &&
				(clearAll || (search.length === 0 && searchMyMembers.length === 0 && topicSearch.length === 0))) {
				this.clearMemberList();
			} else {
				this.pageNumber = 1;
				this.getMemberList(this.pageNumber);
			}
		}
	}
	
	handleTopic(event) {
		event.preventDefault();
		event.stopPropagation();
		
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: event.target.dataset.id,
				actionName: 'view'
			}
		});
	}
	
	processError(error) {
		this.error = error;
		this.membersListWrapper = undefined;
	}
}