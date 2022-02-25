/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasStatusComments {
	@AuraEnabled
	public static List<x7sIdeasCommentsWrapper.CommentsModel> getComments(String ideaId) {

		try {
			if(Idea.SObjectType.getDescribe().isAccessible()) {
				Idea currentIdea = [SELECT Id, Status_Summary__c FROM Idea WHERE Id = :ideaId LIMIT 1];
				System.debug('currentIdea: ' + currentIdea.Id + ' + ' + currentIdea.Status_Summary__c);
				if (currentIdea != null && currentIdea.Status_Summary__c != null) {
					List<x7sIdeasCommentsWrapper.CommentsModel> modelList =
						(List<x7sIdeasCommentsWrapper.CommentsModel>)
							JSON.deserialize(currentIdea.Status_Summary__c,
								List<x7sIdeasCommentsWrapper.CommentsModel>.class);
					return modelList;
				}
			}
		} catch (Exception ex) { System.debug('getComments() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());}

		return null;
	}

	@AuraEnabled
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}
}