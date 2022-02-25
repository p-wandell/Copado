/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureContentObjectHelper
{

    public static x7sAdventureContentObject formatContentObject(X7S_Adventure__c theAdventure, List<x7sAdventureStepWrapper> theStepWrapper, Map<String, String> topics){

        x7sAdventureContentObject contentObject = new x7sAdventureContentObject();
        contentObject.adventure = theAdventure;
        contentObject.adventureStepWrapper = theStepWrapper;
        contentObject.topics = topics;
        return contentObject;

    }
}