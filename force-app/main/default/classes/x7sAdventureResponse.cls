/*
 * Copyright (c) 2020. 7Summits Inc.
 */
public with sharing class x7sAdventureResponse
{
    @AuraEnabled public Boolean success{get;set;} // success or failure
    @AuraEnabled public X7S_Adventure_Setting__mdt globalSetting{get;set;} // adventure setup
    @AuraEnabled public x7sAdventureMyProgress adventureProgress{get;set;} // filtered adventure Progress
    @AuraEnabled public List<String> messages{get;set;}  // messages to display
    @AuraEnabled public List<SObject> results{get;set;} // results to iterate over - use this when querying SOjbects directoy
    @AuraEnabled public List<x7sAdventureContentObject> adventureResults {get;set;} // custom results to iterate over - use this when creating a list of custom wrapper classes

    public x7sAdventureResponse(){
        success = true;        
        messages = new List<String>();
        globalSetting = new X7S_Adventure_Setting__mdt();
        adventureProgress = new x7sAdventureMyProgress();
        results = new List<SObject>();        
        adventureResults = new List<x7sAdventureContentObject>();
    }
}