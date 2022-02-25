/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';

import {getHtmlPlainText, custom} from 'c/x7sIdeasBase';
import {registerListener, unregisterAllListeners, fireEvent, inLex, inLexMode} from 'c/x7sShrUtils';
import {CurrentPageReference} from 'lightning/navigation';

import getComments from '@salesforce/apex/x7sIdeasCommentController.getComments';
import addComment from '@salesforce/apex/x7sIdeasCommentController.addComment';
import likeIdeaComment from '@salesforce/apex/x7sIdeasCommentController.likeIdeaComment';
import unlikeIdeaComment from '@salesforce/apex/x7sIdeasCommentController.unlikeIdeaComment';

import labelComments from "@salesforce/label/c.x7sIdeasCommentsLabel";
import labelCommentSingular from "@salesforce/label/c.x7sIdeasCommentSingular";
import labelErrCommentEntry from "@salesforce/label/c.x7sIdeasCommentseErrBlankComment";
import labelAddComment from "@salesforce/label/c.x7sIdeasCommentsLabelAddComment";
import labelSortLatest from "@salesforce/label/c.x7sIdeasCommentsSortLatest";
import labelSortOldest from "@salesforce/label/c.x7sIdeasCommentsSortOldest";
import labelSortMostVoted from "@salesforce/label/c.x7sIdeasCommentsSortMostVotes";
import labelSortLeastVoted from "@salesforce/label/c.x7sIdeasCommentsSortLeastVotes";
import labelCommentUnlike from "@salesforce/label/c.x7sIdeasCommentsBtnUnLike";
import labelCommentLikes from "@salesforce/label/c.x7sIdeasCommentLikesText";
import labelCommentLike from "@salesforce/label/c.x7sIdeasCommentLikesTextSingular";

export default class X7sIdeasComments extends LightningElement {
	
	@api recordId;
	@api zoneName = 'Internal Zone';
	@api userProfileURL = "/profile/";
	@api numComments = 5;
	@api showPagination = false;
	@api showSort = false;
	@api sortOrder = "LatestComment";
	@api allowComment = false;
	@api allowHtml = false;
	@api enableCanComment = "true";
	@api listId = 'ID_1';
	
	sitePrefix;
	showNickName = true;
	comments=[];
	newComment = "";
	validity = true;
	userProfileSuffix = "";
	likeSeparator = "･";
	showSpinner = false;
	
	//Pagination
	pageNumber = 1;
	totalRecords = 0;
	totalPages = 0;
	hasNextPage = false;
	hasPreviousPage = false;
	
	//sorting
	@api sortVariant = 'standard';
	
	labels = {
		labelErrCommentEntry,
		labelAddComment,
		labelCommentUnlike,
		labelCommentLikes,
		labelCommentLike
	};
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		
		registerListener("sortbyevent", this.sortbyhandle, this);
		registerListener("pageprevious", this.previousHandle, this);
		registerListener("pagenext", this.nextHandle, this);
		
		if (inLexMode()) {
			this.userProfileURL = custom.profileUrl.lex;
			this.userProfileSuffix = custom.profileUrl.view;
		} else {
			this.userProfileURL = custom.profileUrl.community;
		}
		this.getCommentsDetails();
	}
	
	renderedCallback() {
		fireEvent(this.pageRef, 'listhasnext', {id: this.listId, value: this.hasNextPage});
		fireEvent(this.pageRef, 'listhasprevious', {id: this.listId, value: this.hasPreviousPage});
		fireEvent(this.pageRef, 'listpagenumber', {id: this.listId, value: this.pageNumber});
		fireEvent(this.pageRef, 'listtotalpages', {id: this.listId, value: this.totalPages});
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}
	
	get showEdit() {
		return this.allowComment && this.enableCanComment;
	}
	
	get title() {
		return this.totalRecords === 1 ? this.totalRecords + ' ' + labelCommentSingular : this.totalRecords + ' ' + labelComments;
	}
	
	get showSorting() {
		return this.showSort && this.totalPages > 0;
	}
	
	get sortBy() {
		return [
			{label: labelSortLatest, value: "LatestComment"},
			{label: labelSortOldest, value: "OldestComment"},
			{label: labelSortMostVoted, value: "MostVotes"},
			{label: labelSortLeastVoted, value: "LeastVotes"}
		
		];
	}
	
	get hideSort() {
		return !this.showSort || this.totalPages < 1;
	}
	
	get showComments() {
		return this.totalRecords > 0;
	}
	
	get hidePagination() {
		return !this.showPagination || this.totalPages < 1;
	}
	
	getCommentsDetails() {
		this.showSpinner = true;
		getComments({
			zoneName: this.zoneName,
			ideaId: this.recordId,
			pageSize: this.numComments,
			pageNumber: this.pageNumber,
			sortOrder: this.sortOrder
		})
			.then(result => {
				this.showSpinner = false;
				let model = result;
				
				if (model.total) {
					this.sitePrefix = model.sitePrefix;
					this.showNickName = model.useNickName;
					
					let userProfileURL = this.userProfileURL;
					let userProfileSuffix = this.userProfileSuffix;
					model.items.forEach(function (item) {
						item.userURLValue = model.sitePrefix + userProfileURL + item.creatorId + userProfileSuffix;
						item.userURLLabel = model.showNickName ? item.nickName : item.creatorName;
						item.likeText = item.upVotes + ' ' + labelCommentLikes;
						item.commentCreatedDate = new Date(item.createdDate);
					});
					
					this.comments = model.items;
					this.totalRecords = model.total;
					this.totalPages = model.pageCount;
					this.hasNextPage = model.pageHasNext;
					this.hasPreviousPage = model.pageHasPrevious;
				}
			})
			.catch(error => {
				this.showSpinner = false;
				console.error("Error Occurred getting comment details:" + error);
			})
	}
	
	handleEventDetail(evt) {
		this.newComment = evt.target.value;
	}
	
	addIdeaComment(event) {
		let htmlString = this.newComment;
		const valid = !!htmlString && !!getHtmlPlainText(htmlString).trim();
		
		if (valid) {
			this.validity = true;
			this.saveComment();
		} else {
			this.validity = false;
		}
	}
	
	saveComment() {
		addComment({
			ideaId: this.recordId,
			commentBody: this.newComment
		})
			.then(result => {
				this.allowHtml = true;
				this.newComment = "";
				this.getCommentsDetails();
			})
	}
	
	likeComment(evt) {
		let id = evt.currentTarget.dataset.recordid;
		if (id) {
			likeIdeaComment({
				commentId: id
			})
				.then(result => {
					this.getCommentsDetails();
				})
				.catch(error => {
					console.error("Error occurred while liking Idea comment:" + error);
				})
		}
	}
	
	unlikeComment(evt) {
		let id = evt.currentTarget.dataset.recordid;
		if (id) {
			unlikeIdeaComment({
				voteId: id
			})
				.then(result => {
					this.getCommentsDetails();
				})
				.catch(error => {
					console.error("Error occurred while unliking Idea comment:" + error);
				})
		}
	}
	
	sortbyhandle(evt) {
		if (this.listId === evt.id) {
			let sortBy = evt.value;
			this.sortOrder = sortBy.trim();
			this.getCommentsDetails();
		}
	}
	
	previousHandle(evt) {
		if (this.listId === evt.id) {
			this.pageNumber = this.pageNumber - 1;
			this.getCommentsDetails();
		}
	}
	
	nextHandle(evt) {
		if (this.listId === evt.id) {
			this.pageNumber = this.pageNumber + 1;
			this.getCommentsDetails();
		}
	}
}