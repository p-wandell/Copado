/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

/*
@Class Name		  : x7sNewsWrapper
@Created by		  :
@Description		 : Apex class for handling operations with the News Like record. This is without sharing to handle
                        operations on the "News Likes" (Child object) when News (Master object) is set to private for the org.

Vikram Sisodia Apr 2020 :Changed the class/method from global to public & from without sharing to with sharing based on the security scan report
*/
global with sharing class x7sNewsLikeController
{

    /*
	@Name		  :  isLiking
	@Description   :  Method to return true or false if the current user is liking the provided news record
	@Param - recordId: Id of the news record
	*/
    global static Boolean isLiking(String recordId) {
        return getNewsLikeRecords(recordId, UserInfo.getUserId()).size() > 0;
    }

    /*
	@Name		  :  likeNews
	@Description   :  Method to add a like for the current user on the provided news record
	@Param - recordId: Id of the news record
	*/
    global static Boolean likeNews(String recordId){
        if (!X7S_News_Like__c.SObjectType.getDescribe().isCreateable()) {
            System.debug('likeNews(): unable to create X7S_News_Like__c');
            return false;
        }

        List<X7S_News_Like__c> likeRecords = getNewsLikeRecords(recordId, UserInfo.getUserId());
        if(likeRecords != null && likeRecords.size() > 0){
            System.debug('This user already likes this news record');
        } else {
            System.debug(recordId);
            X7S_News_Like__c newsLike = new X7S_News_Like__c();
            newsLike.X7S_News__c = recordId;
            newsLike.User__c = UserInfo.getUserId();

            try{
                insert newsLike;
                return true;
            } catch(Exception ex){
                System.debug('Exception while inserting a new X7S_News_Like__c record: ' + ex);
            }
        }
        return false;
    }

    /*
	@Name		  :  unLikeNews
	@Description   :  Method to remove any like records belonging to the current user for the provided news record.
	                    Note: We current grab any news likes belonging to the user and the news record and then delete
                            them all. No user should be able to like something multiple times, but this is a failsafe.
	@Param - recordId: Id of the news record
	*/
    global static Boolean unLikeNews(String recordId){
        if (!X7S_News_Like__c.SObjectType.getDescribe().isDeletable()) {
            System.debug('unLikeNews() : Unable to delete X7S_News_Like__c');
            return false;
        }

        List<X7S_News_Like__c> likeRecords = getNewsLikeRecords(recordId, UserInfo.getUserId());
        if(likeRecords != null && likeRecords.size() > 0){
            try{
                delete likeRecords;
                return true;
            } catch(Exception ex){
                System.debug('Exception while deleting X7S_News_Like__c record: ' + ex);
            }
        }
        return false;
    }

    /*
	@Name		  :  getNewsLikeRecord
	@Description   :  Helper method to handle the query for grabbing News likes belonging to the provided user and news record
	@Param - newsRecordId: Id of the news record
	@Param - userId: Id of the user
	*/
    global static List<X7S_News_Like__c> getNewsLikeRecords(String newsRecordId, String userId){
        List<X7S_News_Like__c> likeRecords = [SELECT Id, X7S_News__c, User__c FROM X7S_News_Like__c WHERE X7S_News__c =: newsRecordId AND User__c =: userId];
        return likeRecords;
    }
}