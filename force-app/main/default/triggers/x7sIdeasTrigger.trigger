/*
 * Copyright (c) 2020. 7Summits Inc.
 */

trigger x7sIdeasTrigger on Idea (before update, after update, after insert) {
	if (Trigger.isBefore) {
		if (Trigger.isUpdate) {
			x7sIdeasTriggerHelper.addStatusCommentOnStatusUpdate(Trigger.new, Trigger.oldMap);
		}
	}
	else {
		if (Trigger.isInsert) {
			x7sIdeasTriggerHelper.createIdeaExtensionRecord(Trigger.new);
		}

		if (Trigger.isUpdate) {
			x7sIdeasTriggerHelper.createExtensionWhenStatusPending(Trigger.new);

			Set<Id> updatedIdeas = new Set<Id>();

			for (Idea item : Trigger.new) {
				if (item.Status != Trigger.oldMap.get(item.Id).Status) {
					updatedIdeas.add(item.Id);
				}
			}

			x7sIdeasNotifications.ideaStatusChange(updatedIdeas);
		}
	}
}