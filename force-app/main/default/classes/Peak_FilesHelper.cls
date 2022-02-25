/**
 * Created by kentheberling on 6/7/18.
 */

public with sharing class Peak_FilesHelper {

    /*
        Get attachments a User added to a Record
     */
    public static Peak_Response getFilesForCurrentUserForRecord(Id userId, Id recordId){

        Peak_Response peakResponse = new Peak_Response();
        try{
            // Query by User and Parent record
            List<Attachment> attachments = [select BodyLength,ContentType, CreatedById, CreatedDate, Id, IsDeleted, Name, ParentId, SystemModstamp
                from Attachment
                where OwnerId =: userId and ParentId = :recordId];
            peakResponse.results = attachments;

            // Get that 75%
            peakResponse.messages.add('Attachments found');
            peakResponse.success = true;
        } catch (Exception e){
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }
        return peakResponse;
    }
}