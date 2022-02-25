@isTest
public class TimecardRollupHelper_Test {
    @testSetup static void setup() {
    	ProjectRollupHelpers_Test.setupTestData(new List<String>{'pse__Assignment__c', 'pse__Proj__c', 'Contact', 'Opportunity', 'Account', 'pse__Milestone__c', 'pse__Est_vs_Actuals__c'});
    }

    @isTest static void testTimecardTriggers() {
        pse__Region__c region = [SELECT Id FROM pse__Region__c LIMIT 1];
        pse__Proj__c project = [SELECT Id, pse__Stage__c FROM pse__Proj__c LIMIT 1];
        pse__Assignment__c assignment = [SELECT Id, pse__Project__c, pse__Resource__c FROM pse__Assignment__c WHERE pse__Project__c =: project.Id LIMIT 1];
        pse__Milestone__c milestone = [SELECT Id FROM pse__Milestone__c WHERE pse__Project__c =: project.Id LIMIT 1];

        Date startDate=Date.newInstance(2021, 04, 04);
        Date endDate=Date.newInstance(2021, 04, 10);
        Test.startTest();
		pse__Timecard_Header__c timecard = new pse__Timecard_Header__c(pse__Assignment__c=assignment.Id, pse__Project__c=project.Id, pse__Monday_Hours__c=8.0,
                                                                       pse__Resource__c=assignment.pse__Resource__c, pse__Start_Date__c=startDate,
                                                                       pse__End_Date__c=endDate, pse__Milestone__c=milestone.Id, pse__Submitted__c=true, pse__approved__c=true);

        insert timecard;
        project.pse__Stage__c='Completed';
        update project;
        update timecard;

        Test.stopTest();
    }
}