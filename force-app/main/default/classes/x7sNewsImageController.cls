/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sNewsImageController {

    final static string  key 				= 'key';
	final static Integer NUMBEROFPAGE 		= 0;
	final static Integer PAGESIZE 			= 250;
	final static string  LANGUAGE 			= 'en_US';
	final static Boolean SHOWABSOLUTEURL 	= true;
	final static String  MANAGEDCONTENTTYPE = 'cms_image';

    // Current community ID
    private static Id communityId {
        get {
           Id networkId = System.Network.getNetworkId();
           if(networkId==null) { networkId = [SELECT Id FROM Network WHERE Name='7Summits Support Community' LIMIT 1][0].Id; }
           return networkId;
        }
    }

    public static Map<Id,String> getImageURL(List<X7S_News__c> newsList) {

        Map<Id,String> newstoImageURLMap = new Map<Id,String>();
        Map<Id,String> newsWithRelatedFiles = new Map<Id,String>();
        Map<Id,String> newsWithExternalURL = new Map<Id,String>();
        Map<Id,String> newsWithStaticResource = new Map<Id,String>();
        Map<Id,String> newsWithCMSImage = new Map<Id,String>();

        for(X7S_News__c news : newsList) {
            switch on news.Image_Type__c {
                when 'Related File' {
                    newsWithRelatedFiles.put(news.Id, news.Image_Reference__c);
                }
                when 'External URL' {
                    newsWithExternalURL.put(news.Id, news.Image_Reference__c);
                }
                when 'Static Resource' {
                    newsWithStaticResource.put(news.Id, news.Image_Reference__c);
                }
                when 'CMS Content' {
                    newsWithCMSImage.put(news.Id, news.Image_Reference__c);
                }
            }
        }
        
        System.debug('------- newsWithRelatedFiles: ' + newsWithRelatedFiles);
        
        //When Image Type = Related File
        if(!newsWithRelatedFiles.isEmpty()) {

            List<Id> listIds = new List<Id>();
            listIds.addAll(newsWithRelatedFiles.keySet());
            
            //Get All document links for news having Image Type = Related File only
            List<ContentDocumentLink> documentLinkList = x7sNewsContentDocument.getContentDocumentLinks(listIds);
            String communityURL = x7sNewsBaseController.getCommunityUrl();

            for (Id newsId : newsWithRelatedFiles.keySet()) {
                Id imageId;
                String imageURL;
                List<ContentDocumentLink> links = x7sNewsContentDocument.containsEntityId(documentLinkList, newsId);
                System.debug('----- links: ' + links);

                //Get the Image Reference field value
                String imageTitle = newsWithRelatedFiles.get(newsId);
                if(imageTitle != null && imageTitle != '') {
                    System.debug('----- imageTitle != null: ' + links);
                    for(ContentDocumentLink docLink : links) {
                        String tempImageTitle = docLink.ContentDocument.Title + '.' + docLink.ContentDocument.FileExtension;
                        if(imageTitle == tempImageTitle) {
                            imageId = docLink.ContentDocument.LatestPublishedVersionId;
                            break;
                        }
                    }
                }
                imageId = imageId == null ? links[0].ContentDocument.LatestPublishedVersionId : null;
                imageURL = imageId != null ? communityURL + x7sNewsContentDocument.FILE_LOCATION + imageId : null;
                newstoImageURLMap.put(newsId, (String)imageURL);
            }
        }

        //When Image Type = External URL
        if(!newsWithExternalURL.isEmpty()) {
            for (Id newsId : newsWithExternalURL.keySet()) {
                if(newsWithExternalURL.get(newsId) != null && newsWithExternalURL.get(newsId) != '') {
                    newstoImageURLMap.put(newsId, (String)(newsWithExternalURL.get(newsId)));
                }
            }
        }

        //When Image Type = Static Resource
        if(!newsWithStaticResource.isEmpty()) {
            for (Id newsId : newsWithStaticResource.keySet()) {
                if(newsWithStaticResource.get(newsId) != null && newsWithStaticResource.get(newsId) != '') {
                    String imageURL = '/resource/' + newsWithStaticResource.get(newsId);
                    newstoImageURLMap.put(newsId, (String) imageURL);
                }
            }
        }

        //When Image Type = CMS Content 
        if(!newsWithCMSImage.isEmpty()) {
            Map<String,String> contentIdToImageURLMap  =  new Map<String,String>();
            contentIdToImageURLMap = getCMSImageURL(newsWithCMSImage);
            if(!contentIdToImageURLMap.isEmpty()) {
                for (Id newsId : newsWithCMSImage.keySet()) {
                    String imageURL = contentIdToImageURLMap.containsKey(newsWithCMSImage.get(newsId)) ? contentIdToImageURLMap.get(newsWithCMSImage.get(newsId)) : '';
                    newstoImageURLMap.put(newsId, (String) imageURL);
                }
            }
        }
        return newstoImageURLMap;
    }

    private static Map<String,String> getCMSImageURL(Map<Id,String> newsWithCMSImage) {
		Map<String,String> imageURLMap = new Map<String,String>();
		List<String> contentIds = new List<String>();

        for (String content : newsWithCMSImage.values()) {
            if(content != null && String.isNotBlank(content) && ((String)content).length() == 18) {
                contentIds.add(content);
            }
        }

        if(communityId != null) {
            imageURLMap =  getCMSImageURLForCommunity(contentIds);
        } 
        // else {
        //     String channelId = (String) getCMSChannelId();
        //     imageURLMap =  getCMSImageURLForChannel(channelId, contentIds);
        // }

		return imageURLMap;
    }
    
    private static Map<String,String> getCMSImageURLForCommunity(List<String> contentIds) {

		Map<String,String> imageURLMap = new Map<String,String>();

		if(contentIds != null && contentIds.size() > 0 && communityId != null) {
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
    
    private static string getCMSChannelId() {
		String channelId = '';
		ConnectApi.ManagedContentChannelCollection channelList = ConnectApi.ManagedContent.getAllDeliveryChannels(0, 1); 
		for(ConnectApi.ManagedContentChannel channel : channelList.channels) {
			channelId = ((ConnectApi.ManagedContentChannel) channel).channelId;
		}
		return channelId;
	}
}