/*
 * Copyright (c) 2021. 7Summits Inc.
 */

public with sharing class x7sAdventureCloneResponse {
    @AuraEnabled public X7S_Adventure_Setting__mdt globalSettings { get; set; } // adventure setup
    @AuraEnabled public String clonedAdventureName { get; set; } // Recommended name
    @AuraEnabled public Boolean exists { get; set; } // Does a clone of this adventure exist for this user.
    @AuraEnabled public X7S_Adventure_Clone_Setting__mdt cloneSettings { get; set; } // adventure clone setting
}