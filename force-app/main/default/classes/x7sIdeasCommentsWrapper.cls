/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasCommentsWrapper {
	public class CommentsModel {
		@AuraEnabled
		public String newStatus;

		@AuraEnabled
		public String changedBy;

		@AuraEnabled
		public Date changedDate;

		@AuraEnabled
		public String commentText;

		@AuraEnabled
		public String changedById;
	}
}