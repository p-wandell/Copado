/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesFolder {

	@AuraEnabled
	public String Id { get; set; }

	@AuraEnabled
	public String ParentId { get; set; }

	@AuraEnabled
	public String Name { get; set; }

	@AuraEnabled
	public String Description { get; set; }

	@AuraEnabled
	public String sharingSetting { get; set; }

	public x7sFilesFolder(String id, String name, String description, String parentId, String setting) {
		this.Id = id;
		this.ParentId = parentId;
		this.Name = name;
		this.Description = description;
		this.sharingSetting = setting;
	}
}