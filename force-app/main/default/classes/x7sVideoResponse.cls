/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sVideoResponse {
    // success or failure
    @AuraEnabled public Boolean success { get; set; }
    // messages to display
    @AuraEnabled public List<String> messages { get; set; }
    // results to iterate over - use this when querying SObjects directoy@AuraEnabled public List<Peak_ContentObject> peakResults{get;set;} // custom results to iterate over - use this when creating a list of custom wrapper classes
    @AuraEnabled public List<Object> results { get; set; }

    public x7sVideoResponse() {
        success = false;
        messages = new List<String>();
        results = new List<Object>();
    }
}