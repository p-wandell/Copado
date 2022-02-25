/*
 * Copyright (c) 2020. 7Summits Inc.
 */

// ===================
// Custom Response wrapper
// ===================
public virtual with sharing class x7sExpResponse {
    @AuraEnabled public Boolean success { get; set; } // success or failure
    @AuraEnabled public List<String> messages { get; set; }  // messages to display
    @AuraEnabled public List<SObject> results { get; set; } // results to iterate over - use this when querying SOjbects directoy
    @AuraEnabled public List<x7sExpContentObject> expResults { get; set; } // custom results to iterate over - use this when creating a list of custom wrapper classes

    public x7sExpResponse() {
        success = true;
        messages = new List<String>();
        results = new List<SObject>();
        expResults = new List<x7sExpContentObject>();
    }
}