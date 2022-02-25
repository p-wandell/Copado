/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sMediaController {

     @AuraEnabled(cacheable=true)
    public static sObject getAudioData(string recordId, string fieldAPIName
                                        , string fieldAPIName2
                                        , string fieldAPIName3
                                         , string fieldAPIName4
                                         , string fieldAPIName5
                                         , string fieldAPIName6){
        Id recId = recordId;
        DescribeSObjectResult describeResult = recId.getSobjectType().getDescribe();
        
        List<String> fieldNames = new List<String>();
        fieldNames.add('Id');
        
        //fieldNames.add('Name');
        if (!String.isBlank(fieldAPIName))
        {
            fieldNames.add(fieldAPIName);
        } 
        if (!String.isBlank(fieldAPIName2) && !fieldNames.contains(fieldAPIName2))
        {
            fieldNames.add(fieldAPIName2);
        } 
        if (!String.isBlank(fieldAPIName3) && !fieldNames.contains(fieldAPIName3))
        {
            fieldNames.add(fieldAPIName3);
        } 
        if (!String.isBlank(fieldAPIName4) && !fieldNames.contains(fieldAPIName4))
        {
            fieldNames.add(fieldAPIName4);
        } 
        if (!String.isBlank(fieldAPIName5) && !fieldNames.contains(fieldAPIName5))
        {
            fieldNames.add(fieldAPIName5);
        } 
        if (!String.isBlank(fieldAPIName6) && !fieldNames.contains(fieldAPIName6))
        {
            fieldNames.add(fieldAPIName6);
        }

        try
        {
            String query = ' SELECT ' + String.join(fieldNames, ',') +
                ' FROM ' + describeResult.getName() + ' WHERE ' + ' id = :recordId ' + ' LIMIT 1 ' ;
            

            System.debug('query::'+query);
            // return generic list of sobjects
            List<SObject> records = Database.query(String.escapeSingleQuotes(query));
            
            System.debug('records ' + JSON.serialize(records[0]));
            SObject objRec = records[0];
                       
            return objRec;
        } 
        catch (Exception e)
        {
            System.debug('Execption ' + e.getMessage()+' Line '+e.getLineNumber());
            return null;
            //throw new AuraException(e.getMessage());
        }
    }
}