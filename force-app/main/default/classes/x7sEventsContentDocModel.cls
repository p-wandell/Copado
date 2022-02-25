/*
 * Copyright (c) 2021. 7Summits Inc.
 */

public with sharing class x7sEventsContentDocModel {

    @AuraEnabled public String latestImageVersionId { get; set; }

    @AuraEnabled public String imageTitle { get; set; }

    @AuraEnabled public Boolean selectedImage { get; set; }
    
    public x7sEventsContentDocModel() {
        this.latestImageVersionId = '';
        this.imageTitle = '';
        this.selectedImage = false;
    }
}