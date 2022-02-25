/*
 * Copyright (c) 2020. 7Summits Inc.
 */
/**
 * @description Batch process to build lookup tables for specified filter fields
 * This batch process can be schedules or invoked manually to update the filter tables
 */
global class x7sMembersFilterBatch implements Database.Batchable<SObject>, Database.Stateful {
    global x7sMembersFilters memberFilters { get; set; }

    global X7S_Members_Filter_Item__mdt filterMeta { get; set; }
    global X7S_Members_Filter__c filter { get; set; }

    // Use a set to avoid duplicates
    global Set<X7S_Members_Filter_Entry__c> entries { get; set; }

    global List<String> records { get; set; }
    global String fieldName { get; set; }
    global String Query { get; set; }
    global Integer Count { get; set; }

    global x7sMembersFilterBatch(String filterName) {
        memberFilters = new x7sMembersFilters();

        filterMeta = memberFilters.getFilterByName(filterName);
        filter = memberFilters.clearFilter(filterName);
        records = memberFilters.getFieldRecords(filterMeta);
        fieldName = memberFilters.getFieldName(filterMeta);
        entries = new Set<X7S_Members_Filter_Entry__c>();

        Count = 0;

        // build the query based on the Custom Metadata settings - Field Name
        Query = 'SELECT ' + filterMeta.Field_Name__c + ' FROM NetworkMember n WHERE n.Member.IsActive = TRUE';
        Query += (Test.isRunningTest() ? ' LIMIT 200' : '');
        System.debug('Members Filter ' + filter.Name + ' Query: ' + Query);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        System.debug('Executing batch for: ' + filter.Name);
        String fieldValue;

        List<NetworkMember> members = (List<NetworkMember>) scope;

        for (NetworkMember nm : members) {
            SObject record = nm;

            for (Integer count = 0; count < records.size(); ++count) {
                if (record != null) {
                    SObject prevRecord = record;
                    record = prevRecord.getSObject(records[count]);
                }
            }

            if (record != null) {
                fieldValue = (String) record.get(fieldName);
                System.debug('    Adding value: ' + fieldValue);

                if (String.isNotBlank(fieldValue)) {
                    entries.add(new X7S_Members_Filter_Entry__c(Filter__c = filter.Id, Name = fieldValue));
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        // save the results
        List<X7S_Members_Filter_Entry__c> entryList = new List<X7S_Members_Filter_Entry__c>(entries);

        Count += entryList.size();
        insert entryList;

        System.debug('Inserted entries : ' + Count);

        memberFilters.notifyBatchCompletion(bc, filter, Count);
    }
}