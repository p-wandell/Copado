/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name		  : SVNSUMMITS_WrapperNews
@Created by		  :
@Description		 : Apex class for handling operations with the News Like record. This is without sharing to handle
                        operations on the "News Likes" (Child object) when News (Master object) is set to private for the org.
*/
global without sharing class SVNSUMMITS_NewsLikeController {

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
        List<News_Like__c> likeRecords = getNewsLikeRecords(recordId, UserInfo.getUserId());
        if(likeRecords != null && likeRecords.size() > 0){
            //This user already likes this news record
        } else {
            System.debug(recordId);
            News_Like__c newsLike = new News_Like__c();
            newsLike.News__c = recordId;
            newsLike.User__c = UserInfo.getUserId();

            try{
                insert newsLike;
                return true;
            } catch(Exception ex){
                System.debug('Exception while inserting a new News_Like__c record: ' + ex);
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
        List<News_Like__c> likeRecords = getNewsLikeRecords(recordId, UserInfo.getUserId());
        if(likeRecords != null && likeRecords.size() > 0){
            try{
                delete likeRecords;
                return true;
            } catch(Exception ex){
                System.debug('Exception while deleting News_Like__c record: ' + ex);
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
    global static List<News_Like__c> getNewsLikeRecords(String newsRecordId, String userId){
        List<News_Like__c> likeRecords = [SELECT Id, News__c, User__c FROM News_Like__c WHERE News__c =: newsRecordId AND User__c =: userId];
        return likeRecords;
    }
}