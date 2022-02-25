/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track, wire} from 'lwc';
import {fireEvent} from 'c/x7sShrUtils';
import {CurrentPageReference} from "lightning/navigation";

import ss_idea_label_myIdeas from '@salesforce/label/c.x7sIdeasFilterMyIdeas';
import ss_idea_label_ideasVotedOn from '@salesforce/label/c.x7sIdeasFilterLabelideasVotedOn';
import ss_idea_label_ideasCommentedOn from '@salesforce/label/c.x7sIdeasFilterIdeasCommentedOn';
import ss_idea_label_ideasSubscribedOn from '@salesforce/label/c.x7sIdeasFilterLabelIdeasSubscribedOn';
import ss_idea_label_myCompanyIdeas from '@salesforce/label/c.x7sIdeasFilterLabelMyCompanyIdeas';
import ss_idea_label_myCompanyVotedIdeas from '@salesforce/label/c.x7sIdeasFiltermyCompanyVotedIdeas';
import ss_idea_label_myCompanyCommentedIdeas from '@salesforce/label/c.x7sIdeasFilterMyCompanyCommentedIdeas';
import ss_idea_label_myCompanySubscribedIdeas from '@salesforce/label/c.x7sIdeasFilterMyCompanySubscribedIdeas';
import ss_idea_label_AccountIdeasFilter from '@salesforce/label/c.x7sIdeasFilterLabelAccountFilter';
import ss_idea_label_myFilters from '@salesforce/label/c.x7sIdeasFilterLabelMyFilters';
import ss_idea_label_IdeasFilter from '@salesforce/label/c.x7sIdeasFilterLabelActivityFilter';

export default class X7sIdeasMultiFilter extends LightningElement {
	
	@api listId = 'ID_1';
	@api filterValue = '';
	@api requireSelectionIdeasFilter = false;
	@api superUser = false;
	
	// Filter Attributes
	
	@api showMyIdeas;
	@api showVoteByMeFilter;
	@api showIdeasCommentedByMeFilter;
	@api showIdeasSubscribedByMeFilter;
	
	//Label Attributes
	myIdeasLabel = ss_idea_label_myIdeas;
	myVotedIdeasLabel = ss_idea_label_ideasVotedOn;
	myCommentedIdeasLabel = ss_idea_label_ideasCommentedOn;
	mySubscribedIdeasLabel = ss_idea_label_ideasSubscribedOn;
	myAccountIdeasLabel = ss_idea_label_myCompanyIdeas;
	myAccountVotedIdeasLabel = ss_idea_label_myCompanyVotedIdeas;
	myAccountCommentedIdeasLabel = ss_idea_label_myCompanyCommentedIdeas;
	myAccountSubscribedIdeasLabel = ss_idea_label_myCompanySubscribedIdeas;
	myAccountIdeasStaticLabel = ss_idea_label_AccountIdeasFilter;
	idealabelmyFilters = ss_idea_label_myFilters;
	myIdeasStaticLabel = ss_idea_label_IdeasFilter;
	
	//Account Filter Attributes
	@api myCompaniesIdeas;
	@api myCompaniesVotedIdeas;
	@api myCompaniesCommentedIdeas;
	@api myCompaniesSubscribedIdeas;
	@track multiplePicklist = [];
	picklistValue;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.multiOptions();
		
		if (this.superUser) {
			this.filterValue = this.myAccountIdeasLabel;
		} else {
			this.filterValue = this.myIdeasLabel;
		}
		
		if (this.requireSelectionIdeasFilter) {
			
			if (this.showMyIdeas) {
				this.getShowMyIdeas();
				
				this.filterValue = this.myIdeasLabel;
				
			} else if (this.showVoteByMeFilter) {
				
				this.getShowVoteByMeFilter();
				
				this.filterValue = this.myVotedIdeasLabel;
				
			} else if (this.showIdeasCommentedByMeFilter) {
				
				this.getShowIdeasCommentedByMeFilter();
				
				this.filterValue = this.myCommentedIdeasLabel;
				
			} else if (this.showIdeasSubscribedByMeFilter) {
				
				this.getShowIdeasSubscribedByMeFilter();
				
				this.filterValue = this.mySubscribedIdeasLabel;
				
			} else if (this.myCompaniesIdeas) {
				
				this.getMyCompaniesIdeas();
				
				this.filterValue = this.myAccountIdeasLabel;
				
			} else if (this.myCompaniesVotedIdeas) {
				
				this.getMyCompaniesVotedIdeas();
				
				this.filterValue = this.myAccountVotedIdeasLabel;
				
			} else if (this.myCompaniesCommentedIdeas) {
				
				this.getMyCompaniesCommentedIdeas();
				
				this.filterValue = this.myAccountCommentedIdeasLabel;
				
			} else if (this.myCompaniesSubscribedIdeas) {
				
				this.getMyCompaniesSubscribedIdeas();
				
				this.filterValue = this.myAccountSubscribedIdeasLabel;
			} else {
				
				this.getShowMyIdeas();
				
				this.filterValue = this.myIdeasLabel;
			}
		}
		
	}
	
	renderedCallback() {
		if (this.requireSelectionIdeasFilter === false) {
			this.picklistValue = this.myIdeasStaticLabel;
		} else {
			this.picklistValue = this.myIdeasLabel;
		}
	}
	
	getShowMyIdeas() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyIdeas: "Display My Ideas Only",
				searchMyVotedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCompanyIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty'
			});
	}
	
	getShowVoteByMeFilter() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyVotedIdeas: "Display My Voted Ideas Only",
				searchMyIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCompanyIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty'
			});
	}
	
	getShowIdeasCommentedByMeFilter() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCommentedIdeas: 'Display My Commented Ideas Only',
				searchMyVotedIdeas: 'empty',
				searchMyIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCompanyIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty'
			});
	}
	
	getShowIdeasSubscribedByMeFilter() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMySubscribedIdeas: 'Display My Subscribed Ideas Only',
				searchMyVotedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'empty',
				searchMyCompanyIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty'
			});
	}
	
	getMyCompaniesIdeas() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCompanyIdeas: 'Display My Company Ideas Only',
				searchMyVotedIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'empty'
			});
	}
	
	getMyCompaniesVotedIdeas() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCompanyIdeas: 'empty',
				searchMyVotedIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'Display My Company Voted Ideas Only',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'empty'
			});
	}
	
	getMyCompaniesCommentedIdeas() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCompanyIdeas: 'empty',
				searchMyVotedIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'Display My Company Commented Ideas Only',
				searchMyCompanySubscribedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'empty'
			});
	}
	
	getMyCompaniesSubscribedIdeas() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCompanyIdeas: 'empty',
				searchMyVotedIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'Display My Company Subscribed Ideas Only',
				searchMySubscribedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'empty'
			});
	}
	
	getEmptyFilter() {
		fireEvent(this.pageRef,
			'ideasfilterevent', {
				id: this.listId,
				searchMyCompanyIdeas: 'empty',
				searchMyVotedIdeas: 'empty',
				searchMyCompanyVotedIdeas: 'empty',
				searchMyCompanyCommentedIdeas: 'empty',
				searchMyCompanySubscribedIdeas: 'empty',
				searchMySubscribedIdeas: 'empty',
				searchMyCommentedIdeas: 'empty',
				searchMyIdeas: 'No'
			});
	}
	
	handleSelectedFilter(event) {
		let filter = event.detail.value;
		//console.log('--filter---' + filter);
		
		if (filter === this.myIdeasLabel) {
			this.getShowMyIdeas();
			
		} else if (filter === this.myVotedIdeasLabel) {
			this.getShowVoteByMeFilter();
			
		} else if (filter === this.myCommentedIdeasLabel) {
			this.getShowIdeasCommentedByMeFilter();
			
		} else if (filter === this.mySubscribedIdeasLabel) {
			this.getShowIdeasSubscribedByMeFilter();
			
		} else if (filter === this.myAccountIdeasLabel) {
			this.getMyCompaniesIdeas();
			
		} else if (filter === this.myAccountVotedIdeasLabel) {
			this.getMyCompaniesVotedIdeas();
			
		} else if (filter === this.myAccountCommentedIdeasLabel) {
			this.getMyCompaniesCommentedIdeas();
			
		} else if (filter === this.myAccountSubscribedIdeasLabel) {
			this.getMyCompaniesSubscribedIdeas();
			
		} else {
			this.getEmptyFilter();
		}
	}
	
	multiOptions() {
		if (this.requireSelectionIdeasFilter === false) {
			this.multiplePicklist.push({label: this.myIdeasStaticLabel, value: this.myIdeasStaticLabel});
		}
		if (this.showMyIdeas) {
			this.multiplePicklist.push({label: this.myIdeasLabel, value: this.myIdeasLabel});
		}
		if (this.showVoteByMeFilter) {
			this.multiplePicklist.push({label: this.myVotedIdeasLabel, value: this.myVotedIdeasLabel});
		}
		if (this.showIdeasCommentedByMeFilter) {
			this.multiplePicklist.push({label: this.myCommentedIdeasLabel, value: this.myCommentedIdeasLabel});
		}
		if (this.showIdeasSubscribedByMeFilter) {
			this.multiplePicklist.push({label: this.mySubscribedIdeasLabel, value: this.mySubscribedIdeasLabel});
		}
		if (this.superUser) {
			if (this.myCompaniesIdeas) {
				this.multiplePicklist.push({label: this.myAccountIdeasLabel, value: this.myAccountIdeasLabel});
			}
			if (this.myCompaniesVotedIdeas) {
				this.multiplePicklist.push({
					label: this.myAccountVotedIdeasLabel,
					value: this.myAccountVotedIdeasLabel
				});
			}
			if (this.myCompaniesCommentedIdeas) {
				this.multiplePicklist.push({
					label: this.myAccountCommentedIdeasLabel,
					value: this.myAccountCommentedIdeasLabel
				});
			}
			if (this.myCompaniesSubscribedIdeas) {
				this.multiplePicklist.push({
					label: this.myAccountSubscribedIdeasLabel,
					value: this.myAccountSubscribedIdeasLabel
				});
			}
		}
		
	}
	
	get filterValChk() {
		return this.filterValue !== '';
	}
}