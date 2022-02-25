/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasCommentList {
	@AuraEnabled
	public Integer statusCode { get; set; }

	@AuraEnabled
	public String statusMessage { get; set; }

	@AuraEnabled
	public String sitePrefix { get; set; }

	@AuraEnabled
	public Boolean useNickName { get; set; }

	@AuraEnabled
	public Decimal total { get; set; }

	@AuraEnabled
	public Decimal pageCount { get; set; }

	@AuraEnabled
	public Decimal pageSize { get; set; }

	@AuraEnabled
	public Decimal pageCurrent { get; set; }

	@AuraEnabled
	public Boolean pageHasNext { get; set; }

	@AuraEnabled
	public Boolean pageHasPrevious { get; set; }

	@AuraEnabled
	public List<Id> commentIds { get; set; }

	@AuraEnabled
	public List<x7sIdeasCommentModel> items { get; set; }

	public x7sIdeasCommentList() {
		statusCode = 0;
		statusMessage = '';
		total = 0;
		pageCount = 0;
		pageSize = 0;
		pageCurrent = 0;
		pageHasNext = false;
		pageHasPrevious = false;

		items = new List<x7sIdeasCommentModel>();
		commentIds = new List<Id>();
	}
}