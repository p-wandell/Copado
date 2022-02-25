/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesIconModel {

    @AuraEnabled
	public String fileType {get; set;}

    @AuraEnabled
	public String iconName {get; set;}

    @AuraEnabled
	public Boolean showPreview {get; set;}

    public x7sFilesIconModel() {
        fileType    = '';
        iconName    = '';
        showPreview = false;
    }
}