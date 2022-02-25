/*
 * Copyright (c) 2020. 7Summits Inc.
 */

// ===================
// Custom Response wrapper
// ===================
public virtual with sharing class x7sFileUploaderResponse {
    @AuraEnabled public Boolean success { get; set; } // success or failure
    @AuraEnabled public List<String> messages { get; set; }  // messages to display
    @AuraEnabled public List<SObject> results { get; set; } // results to iterate over - use this when querying SObjects directory
    @AuraEnabled public List<x7sFileUploaderContentObject> x7sResults { get; set; } // custom results to iterate over - use this when creating a list of custom wrapper classes

    public x7sFileUploaderResponse() {
        success = true;
        messages = new List<String>();
        results = new List<SObject>();
        x7sResults = new List<x7sFileUploaderContentObject>();
    }
}