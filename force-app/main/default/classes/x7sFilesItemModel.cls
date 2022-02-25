/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesItemModel {

    @AuraEnabled
    public String Id { get; set; }

    @AuraEnabled
    public String Title { get; set; }

    @AuraEnabled
    public String ContentModifiedById { get; set; }

    @AuraEnabled
    public Datetime ContentModifiedDate { get; set; }

    @AuraEnabled
    public Integer ContentSize { get; set; }

    @AuraEnabled
    public String Description { get; set; }

    @AuraEnabled
    public String FileExtension { get; set; }

    @AuraEnabled
    public String FileType { get; set; }

    @AuraEnabled
    public Datetime LastReferencedDate { get; set; }

    @AuraEnabled
    public Datetime LastViewedDate { get; set; }

    @AuraEnabled
    public String LinkedEntityId { get; set; }

    @AuraEnabled
    public Datetime CreatedDate { get; set; }

    @AuraEnabled
    public String VersionId { get; set; }

    @AuraEnabled
    public String ImageUrl { get; set; }

    @AuraEnabled
    public Boolean IsFolder { get; set; }

    @AuraEnabled
    public String ParentId { get; set; }

    @AuraEnabled
    public List<String> breadcrumbs { get; set; }

    @AuraEnabled
	public x7sFilesIconListModel iconSetSetting { get; set; }

    public x7sFilesItemModel(ContentDocumentLink docLink) {
        this.Id = docLink.ContentDocument.Id;
        this.Title = docLink.ContentDocument.Title;
        this.ContentModifiedById = docLink.ContentDocument.LastModifiedById;
        this.ContentModifiedDate = docLink.ContentDocument.ContentModifiedDate;
        this.ContentSize = docLink.ContentDocument.ContentSize;
        this.Description = docLink.ContentDocument.Description;
        this.FileExtension = docLink.ContentDocument.FileExtension;
        this.FileType = docLink.ContentDocument.FileType;
        this.LastReferencedDate = docLink.ContentDocument.LastReferencedDate;
        this.LastViewedDate = docLink.ContentDocument.LastViewedDate;
        this.CreatedDate = docLink.ContentDocument.CreatedDate;
        this.VersionId = docLink.ContentDocument.LatestPublishedVersionId;
        this.LinkedEntityId = docLink.LinkedEntityId;
        this.IsFolder = false;
        this.iconSetSetting = getIconSettingForFiles(docLink.LinkedEntityId);
    }

    public x7sFilesItemModel(X7S_File_Folder__c record, String communityUrl, Id imageId, List<String> breadcrumbs) {
        this.Id = record.Id;
        this.Title = (String) record.get('Name');
        this.Description = (String) record.get('Description__c');
        this.LinkedEntityId = (String) record.get('Parent_Folder__c');
        this.IsFolder = true;
        this.breadcrumbs = breadcrumbs;
        this.ParentId = record.Parent_Folder__c;
        this.CreatedDate = record.CreatedDate;
        if (imageId != null && String.isNotBlank(communityUrl)) {
            this.ImageUrl = communityUrl + x7sFilesContentDocument.FILE_LOCATION + imageId;
        }
    }

	@TestVisible
	private static x7sFilesIconListModel getIconSettingForFiles(Id Id) {
		X7S_File_Folder__c IconSetId = [SELECT Sharing_Setting__c FROM X7S_File_Folder__c WHERE Id = :Id WITH SECURITY_ENFORCED LIMIT 1];
		X7S_Files_Setting__mdt settings = X7S_Files_Setting__mdt.getInstance((String) IconSetId.get('Sharing_Setting__c'));

		if (settings != null && settings.X7S_Files_Icon_Set__c != null) {
			x7sFilesIconListModel settingModel = getIconListModel(settings);
			return settingModel;
		}
		return null;
	}

    // Icon List
	@TestVisible
	private static x7sFilesIconListModel getIconListModel(X7S_Files_Setting__mdt settings) {

		if (settings != null) {
			try {
				x7sFilesIconListModel iconListModel = new x7sFilesIconListModel();
				List<X7S_Files_Icon_Set_Assignment__mdt> iconSetAssignment = X7S_Files_Icon_Set_Assignment__mdt.getAll().values();

				for (X7S_Files_Icon_Set_Assignment__mdt iconItem : iconSetAssignment) {
					if (iconItem.X7S_Files_Icon_Set__c == settings.X7S_Files_Icon_Set__c) {
						if (iconSetAssignment.size() > 0) {
							List<X7S_Files_Icon_Set__mdt> iconSet = X7S_Files_Icon_Set__mdt.getAll().values();
							for (X7S_Files_Icon_Set__mdt icon : iconSet) {
								if (icon.Id == iconItem.X7S_Files_Icon_Set__c) {
									X7S_Files_Icon__mdt iconField = X7S_Files_Icon__mdt.getInstance(iconItem.X7S_Files_Icon__c);
									if (iconField.Icon_Name__c != null && iconField != null) {
										iconListModel.fileIconList.add(getIconModel(iconField,icon.Show_Preview__c));
									}
								}
							}
						}
					}
				}
				return iconListModel;
			}
			catch (QueryException ex) {
				System.debug('Error occurred getting Icon set assignment: ' + ex.getMessage());
			}
		}
		return null;
	}

    private static x7sFilesIconModel getIconModel(X7S_Files_Icon__mdt iconField, Boolean showPreview) {
		x7sFilesIconModel model = new x7sFilesIconModel();
		if (iconField.Icon_Name__c != null) {
			model.fileType = (String) iconField.File_Type__c;
			model.iconName = (String) iconField.Icon_Name__c;
			model.showPreview = showPreview;
		}
		return model;
	}

}