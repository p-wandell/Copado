/*
 * Copyright (c) 2020. 7Summits Inc.
 */

trigger x7sAdventureDocLinkTrigger on ContentDocumentLink (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if (Trigger.isUpdate || Trigger.isInsert && Trigger.isBefore) {
        x7sAdventureDocLinkTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}