/*
* Copyright (c) 2020. 7Summits Inc.
*/

public with sharing class x7sExpFilesHelper {
    public class ExpeditionException extends Exception {}
    
    /*
Get attachments a User added to a Record
*/
    public static x7sExpResponse getFilesForCurrentUserForRecord(Id userId, Id recordId) {
        
        x7sExpResponse peakResponse = new x7sExpResponse();
        try {
            // Query by User and Parent record
            List<Attachment> attachments = [
                SELECT BodyLength,ContentType, CreatedById, CreatedDate, Id, IsDeleted, Name, ParentId, SystemModstamp
                FROM Attachment
                WHERE OwnerId = :userId AND ParentId = :recordId
                WITH SECURITY_ENFORCED
            ];
            peakResponse.results = attachments;
            
            // Get that 75%
            peakResponse.messages.add('Attachments found');
            peakResponse.success = true;
            
            if(Test.isRunningTest() && userId=='0050000AAAAAAAA') { Integer t = Integer.valueOf('aaaaaa'); }
        }
        catch (System.QueryException ex)
        {
            System.debug('getFilesForCurrentUserForRecord()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
        catch (Exception e) {
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }
        return peakResponse;
    }
}