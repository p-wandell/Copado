/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesIconListModel {

    @AuraEnabled
	public List<x7sFilesIconModel> fileIconList {get; set;}

    public x7sFilesIconListModel() {
        fileIconList = new List<x7sFilesIconModel>();
    }
}