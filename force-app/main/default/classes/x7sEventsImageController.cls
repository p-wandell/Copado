/*
 * Copyright (c) 2021. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sEventsImageController {

    final static string  key 				= 'key';
	final static Integer NUMBEROFPAGE 		= 0;
	final static Integer PAGESIZE 			= 250;
	final static string  LANGUAGE 			= 'en_US';
	final static Boolean SHOWABSOLUTEURL 	= true;
	final static String  MANAGEDCONTENTTYPE = 'cms_image';

    // Current community ID
    @TestVisible
    private static Id communityId {
        get {
           return System.Network.getNetworkId();
        }
    }

    /**
     * Get List of Image Types from Event Object
     * @return List of Image Types
     */

    @AuraEnabled
    public static Map<String,String> getImageTypes() {
        Map<String,String> options = new Map<String,String>();
                
        Schema.DescribeFieldResult fieldResult = X7S_Event__c.Image_Type__c.getDescribe();
        List<Schema.PicklistEntry> imageTypes = fieldResult.getPicklistValues();
                
        for(Schema.PicklistEntry type : imageTypes) {
            options.put(type.getValue(), type.getLabel());
        }       
        return options;
    }

    public static Map<Id,String> getImageURL(List<X7S_Event__c> eventList) {

        Map<Id,String> eventToImageURLMap = new Map<Id,String>();
        Map<Id,String> eventsWithRelatedFiles = new Map<Id,String>();
        Map<Id,String> eventsWithExternalURL = new Map<Id,String>();
        Map<Id,String> eventsWithStaticResource = new Map<Id,String>();
        Map<Id,String> eventsWithCMSImage = new Map<Id,String>();

        for(X7S_Event__c event : eventList) {
            switch on event.Image_Type__c {
                when 'Related File' {
                    eventsWithRelatedFiles.put(event.Id, event.Image_Reference__c);
                }
                when 'External URL' {
                    eventsWithExternalURL.put(event.Id, event.Image_Reference__c);
                }
                when 'Static Resource' {
                    eventsWithStaticResource.put(event.Id, event.Image_Reference__c);
                }
                when 'CMS Content' {
                    eventsWithCMSImage.put(event.Id, event.Image_Reference__c);
                }
            }
        }
        
        //When Image Type = Related File
        if(!eventsWithRelatedFiles.isEmpty()) {

            List<Id> listIds = new List<Id>();
            listIds.addAll(eventsWithRelatedFiles.keySet());
            
            //Get All document links for event having Image Type = Related File only
            List<ContentDocumentLink> documentLinkList = x7sEventsContentDocument.getContentDocumentLinks(listIds);
            String communityURL = x7sEventsBaseController.getCommunityUrl();

            for (Id eventId : eventsWithRelatedFiles.keySet()) {
                Id imageId;
                String imageURL;
                List<ContentDocumentLink> links = x7sEventsContentDocument.containsEntityId(documentLinkList, eventId);

                //Get the Image Reference field value
                String imageRef = eventsWithRelatedFiles.get(eventId);
                if(imageRef != null && imageRef != '') {
                    for(ContentDocumentLink docLink : links) {
                        if(docLink.ContentDocument.LatestPublishedVersionId == imageRef) {
                            imageId = docLink.ContentDocument.LatestPublishedVersionId;
                            break;
                        }
                    }
                }
                if(imageId == null) {
                    if(links.size() > 0) {
                        imageURL = communityURL + x7sEventsContentDocument.FILE_LOCATION + links[0].ContentDocument.LatestPublishedVersionId;
                    }
                } else {
                    imageURL = communityURL + x7sEventsContentDocument.FILE_LOCATION + imageId;
                }
                if(imageURL != null) {
                    eventToImageURLMap.put(eventId, (String)imageURL);
                }
            }
        }

        //When Image Type = External URL
        if(!eventsWithExternalURL.isEmpty()) {
            for (Id eventId : eventsWithExternalURL.keySet()) {
                if(eventsWithExternalURL.get(eventId) != null && eventsWithExternalURL.get(eventId) != '') {
                    eventToImageURLMap.put(eventId, (String)(eventsWithExternalURL.get(eventId)));
                }
            }
        }

        //When Image Type = Static Resource
        if(!eventsWithStaticResource.isEmpty()) {
            for (Id eventId : eventsWithStaticResource.keySet()) {
                if(eventsWithStaticResource.get(eventId) != null && eventsWithStaticResource.get(eventId) != '') {
                    String imageURL = '/resource/' + eventsWithStaticResource.get(eventId);
                    eventToImageURLMap.put(eventId, (String) imageURL);
                }
            }
        }

        //When Image Type = CMS Content 
        if(!eventsWithCMSImage.isEmpty()) {
            Map<String,String> contentIdToImageURLMap  =  new Map<String,String>();
            contentIdToImageURLMap = getCMSImageURL(eventsWithCMSImage, new List<String>());
            if(!contentIdToImageURLMap.isEmpty()) {
                for (Id eventId : eventsWithCMSImage.keySet()) {
                    String imageURL = contentIdToImageURLMap.containsKey(eventsWithCMSImage.get(eventId)) ? contentIdToImageURLMap.get(eventsWithCMSImage.get(eventId)) : '';
                    eventToImageURLMap.put(eventId, (String) imageURL);
                }
            }
        }
        return eventToImageURLMap;
    }

    /**
    * Get Image URL of the image stored in the CMS
    * @param    eventsWithCMSImage : Event Ids to CMS Content Ids Map
    * @param    contectIdList : List of CMS Content Ids
    * @return   imageURLMap : CMS Content Id to content image URL Map
    **/ 
    @AuraEnabled
    public static Map<String,String> getCMSImageURL(Map<Id,String> eventsWithCMSImage, List<String> contectIdList) {
        Map<String,String> imageURLMap = new Map<String,String>();
		List<String> contentIds = new List<String>();

        if(!eventsWithCMSImage.isEmpty()) {
            for (String content : eventsWithCMSImage.values()) {
                if(content != null && String.isNotBlank(content) && ((String)content).length() == 18) {
                    contentIds.add(content);
                }
            }
        } else if(contectIdList.size() > 0 && contectIdList != null) {
            contentIds.addAll(contectIdList);
        }

        if(communityId != null) {
            imageURLMap =  getCMSImageURLForCommunity(contentIds);
        } 
        else {
            String channelId = (String) getCMSChannelId();
            imageURLMap =  getCMSImageURLForChannel(channelId, contentIds);
        }

		return imageURLMap;
    }
    
    @TestVisible
    private static Map<String,String> getCMSImageURLForCommunity(List<String> contentIds) {

		Map<String,String> imageURLMap = new Map<String,String>();

		if(contentIds != null && contentIds.size() > 0) {
			try {
				ConnectApi.ManagedContentVersionCollection contentList = 
				ConnectApi.ManagedContent.getManagedContentByIds(communityId, contentIds, NUMBEROFPAGE, PAGESIZE, LANGUAGE, MANAGEDCONTENTTYPE, SHOWABSOLUTEURL);
				if(contentList != null) {
					for(String contentId : contentIds) {
						for(ConnectApi.ManagedContentVersion cmsContent : contentList.items) {
							if(cmsContent.managedContentId == contentId) {
								imageURLMap.put(contentId, ((ConnectApi.ManagedContentMediaSourceNodeValue) cmsContent.contentNodes.get('source')).url);
							}
						}
					}
				}
			}
			catch (Exception e) {
				System.debug('getCMSImageURLForCommunity() : ' + e.getMessage() + ' line number: ' + e.getLineNumber());
			}
		}
		return imageURLMap;
    }

    private static Map<String,String> getCMSImageURLForChannel(String channelId, List<String> contentIds) {
		Map<String,String> imageURLMap = new Map<String,String>();

		if(contentIds != null && contentIds.size() > 0 && channelId != null) {
			DateTime startDate = DateTime.newInstanceGMT(2015, 6, 6, 0, 0, 0);
			String sDate =  startDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
			DateTime endDate = DateTime.now();
			String edate =  endDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

			try {
				ConnectApi.ManagedContentVersionCollection contentList = 
				ConnectApi.ManagedContent.getContentByIds(channelId, contentIds, NUMBEROFPAGE, PAGESIZE, LANGUAGE, MANAGEDCONTENTTYPE, true, sDate, edate, SHOWABSOLUTEURL);
				if(contentList != null) {
					for(String contentId : contentIds) {
						for(ConnectApi.ManagedContentVersion cmsContent : contentList.items) {
							if(cmsContent.managedContentId == contentId) {
								imageURLMap.put(contentId, ((ConnectApi.ManagedContentMediaSourceNodeValue) cmsContent.contentNodes.get('source')).url);
							}
						}
					}
				}
			}
			catch (Exception e) {
				System.debug('getCMSImageURLForChannel() : ' + e.getMessage() + ' line number: ' + e.getLineNumber());
			}
        }
		return imageURLMap;
	}
    
    private static string getCMSChannelId() {
		String channelId = '';
		ConnectApi.ManagedContentChannelCollection channelList = ConnectApi.ManagedContent.getAllDeliveryChannels(0, 1); 
		for(ConnectApi.ManagedContentChannel channel : channelList.channels) {
			channelId = ((ConnectApi.ManagedContentChannel) channel).channelId;
		}
		return channelId;
	}
}