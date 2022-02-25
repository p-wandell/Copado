/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasCommentModel {
	@AuraEnabled
	public String id, ideaId, zoneId, commentBody, creatorId, creatorName, nickName, fullPhotoUrl, smallPhotoUrl;

	@AuraEnabled
	public Datetime createdDate;

	@AuraEnabled
	public Boolean isHtml, likedByUser;

	// Votes
	@AuraEnabled
	public Integer upVotes;

	@AuraEnabled
	public String voteId;

	public x7sIdeasCommentModel() {
		id = '';
		ideaId = '';
		zoneId = '';
		commentBody = '';
		creatorId = '';
		creatorName = '';
		nickName = '';
		fullPhotoUrl = '';
		smallPhotoUrl = '';
		isHtml = false;
		upVotes = 0;
		voteId = '';
	}
}