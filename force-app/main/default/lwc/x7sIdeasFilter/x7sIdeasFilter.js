/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference} from "lightning/navigation";

import {fireEvent,inLexMode} from 'c/x7sShrUtils';
import getTopicNamesList from "@salesforce/apex/x7sIdeasFiltersController.getTopicNamesList";
import getCategoryValues from "@salesforce/apex/x7sIdeasFiltersController.getCategoryValues";
import getStatusValues from '@salesforce/apex/x7sIdeasFiltersController.getStatusValues';
import getThemeValues from '@salesforce/apex/x7sIdeasFiltersController.getThemeValues';
import getShowAccountFilter from '@salesforce/apex/x7sIdeasFiltersController.showAccountFilter';

import ss_idea_label_topics from '@salesforce/label/c.x7sIdeasFilterLabelTopics';
import ss_idea_label_Categories from '@salesforce/label/c.x7sIdeasFilterLabelCategories';
import x7s_Select_All from '@salesforce/label/c.x7sIdeasFilterSelectAll';
import ss_idea_label_ideasSubscribedOn from '@salesforce/label/c.x7sIdeasFilterLabelIdeasSubscribedOn';
import ss_idea_label_ideasCommentedOn from '@salesforce/label/c.x7sIdeasFilterIdeasCommentedOn';
import ss_idea_label_ideasVotedOn from '@salesforce/label/c.x7sIdeasFilterLabelideasVotedOn';
import ss_idea_label_myIdeas from '@salesforce/label/c.x7sIdeasFilterMyIdeas';
import ss_idea_label_Status from '@salesforce/label/c.x7sIdeasFilterLabelStatus';
import ss_idea_label_Themes from '@salesforce/label/c.x7sIdeasFilterlabelThemes';
import ss_idea_label_myCompanySubscribedIdeas from '@salesforce/label/c.x7sIdeasFilterMyCompanySubscribedIdeas';
import ss_idea_label_myCompanyCommentedIdeas from '@salesforce/label/c.x7sIdeasFilterMyCompanyCommentedIdeas';
import ss_idea_label_myCompanyVotedIdeas from '@salesforce/label/c.x7sIdeasFiltermyCompanyVotedIdeas';
import ss_idea_label_myCompanyIdeas from '@salesforce/label/c.x7sIdeasFilterLabelMyCompanyIdeas';
import label_AriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";

export default class X7sIdeasFilter extends LightningElement {
	
	@api zoneName = 'Internal Zone';
	@api variant = 'None';
	@api customClass = '';
	@api listId = 'ID_1';
	@api TopicValue;
	@api StatusValue;
	@api CatValue;
	@api showMyIdeas = "true";
	@api showVoteByMeFilter = "true";
	@api showIdeasCommentedByMeFilter = "true";
	@api showIdeasSubscribedByMeFilter = "true";
	@api myCompaniesIdeas = "true";
	@api myCompaniesVotedIdeas = "true";
	@api myCompaniesCommentedIdeas = "true";
	@api myCompaniesSubscribedIdeas = "true";
	@api requireSelectionIdeasFilter = false;
	@api showTopicFilter = "true";
	@api showCategoryFilter = "true";
	@api showStatusFilter = "true";
	@api showThemesFilter = "true";
	myIdeas = false;
	votedIdeas = false;
	showFilterRow = true;
	multipleFiltersActive = false;
	commentedIdeas = false;
	subscribedIdeas = false;
	superUser = false;
	myAccountIdeas = false;
	myAccountVotedIdeas = false;
	myAccountCommentedIdeas = false;
	myAccountSubscribedIdeas = false;
	filterValue;
	topicNamesList;
	categoriesSet;
	statusList;
	themesList;
	topicLabel = ss_idea_label_topics;
	catLabel = ss_idea_label_Categories;
	selectAll = x7s_Select_All;
	statusLabel = ss_idea_label_Status;
	themeLabel = ss_idea_label_Themes;
	myideaLabel = ss_idea_label_myIdeas;
	ideaVotedLabel = ss_idea_label_ideasVotedOn;
	ideasCommentedOnLabel = ss_idea_label_ideasCommentedOn;
	ideasSubscribedOnLabel = ss_idea_label_ideasSubscribedOn;
	myAccountIdeasLabel = ss_idea_label_myCompanyIdeas;
	myCompanyVotedIdeasLabel = ss_idea_label_myCompanyVotedIdeas;
	myCompanyCommentedIdeasLabel = ss_idea_label_myCompanyCommentedIdeas;
	myCompanySubscribedIdeasLabel = ss_idea_label_myCompanySubscribedIdeas;
	labelAriaWrapper = label_AriaWrapper;
	error;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.multipleFiltersActive = this.getFilterCount() > 1;
		
		this.showAccountFilters();
		this.getTopicValues();
		this.getCategoryValues();
		this.getStatusValue();
		this.getThemeValue();
	}
	
	get componentClass() {
		return `x7s-ideas-filters ${this.customClass}`;
	}
	
	get myIdeaShow() {
		return (this.showMyIdeas === true && this.multipleFiltersActive === false);
	}
	
	get myIdeaVoted() {
		return (this.showVoteByMeFilter === true && this.multipleFiltersActive === false);
	}
	
	get ideasCommentedOn() {
		return (this.showIdeasCommentedByMeFilter === true && this.multipleFiltersActive === false);
	}
	
	get ideasSubscribedByMe() {
		return (this.showIdeasSubscribedByMeFilter === true && this.multipleFiltersActive === false);
	}
	
	get ideasFilterMyAccount() {
		return (this.myCompaniesIdeas === true && this.multipleFiltersActive === false);
	}
	
	get ideasMyCompanyCommented() {
		return (this.myCompaniesCommentedIdeas === true && this.multipleFiltersActive === false);
	}
	
	get ideasmyAccountSubscribedIdeas() {
		return (this.myCompaniesSubscribedIdeas === true && this.multipleFiltersActive === false);
	}
	
	get ideasMultiFilter() {
		return ((this.multipleFiltersActive && this.showMyIdeas) ||
			(this.multipleFiltersActive && (this.myCompaniesIdeas && this.superUser)));
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	get autoSlds() {
		return inLexMode();
	}
	showAccountFilters() {
		let count = this.getFilterCount();
		
		if (count > 0) {
			getShowAccountFilter().then(result => {
				let superUser = result;
				this.superUser = superUser;
				//console.log('---superUser from apex--' + this.superUser);
				if ((superUser && this.myCompaniesIdeas) &&
					(this.requireSelectionIdeasFilter && (count > 1))) {
					this.filterValue = this.myAccountIdeasLabel;
					fireEvent(this.pageRef,
						'ideasfilterevent', {
							id: this.listId,
							searchMyCompanyIdeas: 'Display My Company Ideas Only',
							searchMyCommentedIdeas: 'empty',
							searchMySubscribedIdeas: 'empty',
							searchMyVotedIdeas: 'empty',
							searchMyIdeas: 'empty',
							searchMyCompanyVotedIdeas: 'empty',
							searchMyCompanyCommentedIdeas: 'empty',
							searchMyCompanySubscribedIdeas: 'empty'
						});
				} else if (this.requireSelectionIdeasFilter && (count > 1) && this.showMyIdeas) {
					this.filterValue = this.myideaLabel;
					fireEvent(this.pageRef,
						'ideasfilterevent', {
							id: this.listId,
							searchMyIdeas: 'Display My Ideas Only',
							searchMyVotedIdeas: 'empty',
							searchMyCommentedIdeas: 'empty',
							searchMySubscribedIdeas: 'empty',
							searchMyCompanyIdeas: 'empty',
							searchMyCompanyVotedIdeas: 'empty',
							searchMyCompanyCommentedIdeas: 'empty',
							searchMyCompanySubscribedIdeas: 'empty'
						});
				} else {
					this.filterValue = 'none';
				}
			}).catch(error => {
				this.error = error;
			});
		}
	}
	
	getFilterCount() {
		let count = 0;
		if (this.showMyIdeas)
			count++;
		if (this.showVoteByMeFilter)
			count++;
		if (this.showIdeasCommentedByMeFilter)
			count++;
		if (this.showIdeasSubscribedByMeFilter)
			count++;
		if (this.myCompaniesIdeas)
			count++;
		if (this.myCompaniesVotedIdeas)
			count++;
		if (this.myCompaniesCommentedIdeas)
			count++;
		if (this.myCompaniesSubscribedIdeas)
			count++;
		return count;
	}
	
	showFilterRows() {
		let showMyIdeas = this.showMyIdeas;
		let showCategoryFilter = this.showCategoryFilter;
		let showTopicFilter = this.showTopicFilter;
		let showStatusFilter = this.showStatusFilter;
		let showThemesFilter = this.showThemesFilter;
		let showViewSelector = this.showViewSelector;
		this.showFilterRow = (showMyIdeas || showCategoryFilter || showTopicFilter || showStatusFilter || showThemesFilter || showViewSelector);
	}
	
	getTopicValues() {
		let topicValues = this.TopicValue;
		
		if (topicValues && topicValues.trim() !== '') {
			let data = topicValues.split(',');
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({
				label: this.selectAll,
				value: this.selectAll
			});
			this.topicNamesList = res;
			
		} else {
			getTopicNamesList().then(result => {
				let data = result;
				
				let res = Object.keys(data).map((key) => {
					return ({label: data[key], value: data[key]});
				});
				res.unshift({
					label: this.selectAll,
					value: this.selectAll
				});
				this.topicNamesList = res;
			}).catch(error => {
				this.error = error;
			});
		}
	}
	
	getStatusValue() {
		let StatusValue = this.StatusValue;
		
		if (StatusValue && StatusValue.trim() !== '') {
			let data = StatusValue.split(',');
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({
				label: this.selectAll,
				value: this.selectAll
			});
			this.statusList = res;
			
		} else {
			getStatusValues({
				objName: "Idea",
				fieldName: "Status"
			}).then(result => {
				let data = result;
				
				let res = Object.keys(data).map((key) => {
					return ({label: data[key], value: data[key]});
				});
				res.unshift({
					label: this.selectAll,
					value: this.selectAll
				});
				this.statusList = res;
			}).catch(error => {
				this.error = error;
			});
		}
	}
	
	getCategoryValues() {
		let CatValue = this.CatValue;
		
		if (CatValue && CatValue.trim() !== '') {
			let data = CatValue.split(',');
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({
				label: this.selectAll,
				value: this.selectAll
			});
			this.categoriesSet = res;
			
		} else {
			getCategoryValues().then(result => {
				let data = result;
				
				let res = Object.keys(data).map((key) => {
					return ({label: data[key], value: data[key]});
				});
				res.unshift({
					label: this.selectAll,
					value: this.selectAll
				});
				this.categoriesSet = res;
			}).catch(error => {
				this.error = error;
			});
		}
	}
	
	getThemeValue() {
		getThemeValues().then(result => {
			let data = result;
			
			let res = Object.keys(data).map((key) => {
				return ({label: data[key], value: data[key]});
			});
			res.unshift({
				label: this.selectAll,
				value: this.selectAll
			});
			this.themesList = res;
		}).catch(error => {
			this.error = error;
		});
	}
	
	filterByTopics(event) {
		let filter = event.detail.value;
		let clear = this.selectAll;
		
		let searchByTopics = filter === clear ? ' ' : filter;
		fireEvent(this.pageRef, 'ideasfiltertopic', {id: this.listId, searchByTopics: searchByTopics});
	}
	
	filterByStatus(event) {
		let filter = event.detail.value;
		let clear = this.selectAll;
		
		let searchByStatus = filter === clear ? ' ' : filter;
		fireEvent(this.pageRef, 'ideasfilterstatus', {id: this.listId, searchByStatus: searchByStatus});
	}
	
	filterByCategory(event) {
		let filter = event.detail.value;
		let clear = this.selectAll;
		
		let searchByCategory = filter === clear ? ' ' : filter;
		fireEvent(this.pageRef, 'ideasfiltercategory', {id: this.listId, searchByCategory: searchByCategory});
	}
	
	filterByTheme(event) {
		let filter = event.detail.value;
		let clear = this.selectAll;
		
		let searchByTheme = filter === clear ? ' ' : filter;
		fireEvent(this.pageRef, 'ideasfiltertheme', {id: this.listId, searchByTheme: searchByTheme});
	}
	
	filterByMyIdeas(event) {
		let filter = event.target.checked;
		let searchMyIdeas = filter ? 'Display My Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {id: this.listId, searchMyIdeas: searchMyIdeas});
	}
	
	filterByIdeasVotedOn(event) {
		let filter = event.target.checked;
		let searchMyVotedIdeas = filter ? 'Display My Voted Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {id: this.listId, searchMyVotedIdeas: searchMyVotedIdeas});
	}
	
	filterBycommentedIdeas(event) {
		let filter = event.target.checked;
		let searchMyCommentedIdeas = filter ? 'Display My Commented Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {id: this.listId, searchMyCommentedIdeas: searchMyCommentedIdeas});
	}
	
	filterByIdeasSubscribedOn(event) {
		let filter = event.target.checked;
		let searchMySubscribedIdeas = filter ? 'Display My Subscribed Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {
			id: this.listId,
			searchMySubscribedIdeas: searchMySubscribedIdeas
		});
	}
	
	filterByMyCompanyIdeas(event) {
		let filter = event.target.checked;
		let searchMyCompanyIdeas = filter ? 'Display My Company Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {id: this.listId, searchMyCompanyIdeas: searchMyCompanyIdeas});
	}
	
	filterByMyCompanyVotedIdeas(event) {
		let filter = event.target.checked;
		let searchMyCompanyVotedIdeas = filter ? 'Display My Company Voted Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {
			id: this.listId,
			searchMyCompanyVotedIdeas: searchMyCompanyVotedIdeas
		});
	}
	
	filterByMyCompanyCommentedIdeas(event) {
		let filter = event.target.checked;
		let searchMyCompanyCommentedIdeas = filter ? 'Display My Company Commented Ideas Only' : ' '
		fireEvent(this.pageRef, 'ideasfilterevent', {
			id: this.listId,
			searchMyCompanyCommentedIdeas: searchMyCompanyCommentedIdeas
		});
	}
	
	filterByMyCompanySubscribedIdeas(event) {
		let filter = event.target.checked;
		let searchMyCompanySubscribedIdeas = filter ? 'Display My Company Subscribed Ideas Only' : ' ';
		fireEvent(this.pageRef, 'ideasfilterevent', {
			id: this.listId,
			searchMyCompanySubscribedIdeas: searchMyCompanySubscribedIdeas
		});
	}
}