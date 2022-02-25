/*
 * Copyright (c) 2020. 7Summits Inc.
 */

trigger x7sIdeasCommentTrigger on IdeaComment (after insert) {
	Set<Id> ideaCommentIds = new Set<Id>();

	for (IdeaComment newComment : Trigger.new) {
		ideaCommentIds.add(newComment.Id);
	}

	x7sIdeasNotifications.ideaNewComment(ideaCommentIds);
}