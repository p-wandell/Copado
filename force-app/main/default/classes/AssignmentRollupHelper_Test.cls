@isTest (SeeAllData=false)
public class AssignmentRollupHelper_Test {
    @testSetup static void setup() {
        ProjectRollupHelpers_Test.setupTestData(new List<String>{'Contact', 'pse__Est_vs_Actuals__c'});
        
    }
    
    @isTest static void testDelete() {
        System.debug('---------------- STARTING testDelete METHOD ----------------');
        AssignmentRollupHelper.isRunning=false;
        TriggerState.resetThisTrigger('x7sAssignmentTrigger');
        TriggerState.resetThisTrigger('pse__Assignment__c');
        pse__Assignment__c assignment = [SELECT Id, pse__Project__c, pse__is_billable__c, pse__Bill_Rate__c FROM pse__Assignment__c LIMIT 1];
        pse__Proj__c project = [SELECT Id, pse__Stage__c FROM pse__Proj__c WHERE Id =: assignment.pse__Project__c];
        
        Test.startTest();
        delete assignment;
        Test.stopTest();
    }
   
    @isTest static void testCompleted() {  
        System.debug('---------------- STARTING testCompleted METHOD ----------------');
        EstVsActualsRollupHelper.isRunning=true;
        
        pse__Assignment__c assignment = [SELECT Id, pse__Project__c, pse__is_billable__c, pse__Bill_Rate__c FROM pse__Assignment__c LIMIT 1];
        pse__Proj__c project = [SELECT Id, pse__Stage__c FROM pse__Proj__c WHERE Id =: assignment.pse__Project__c];
        
        System.debug('---------------- ENTERING INTO TEST ----------------');
        Test.startTest();
        project.pse__Stage__c='Completed';
        update project;
        System.debug('------ updated project: ' + project.Id + '    -------- stage: ' + project.pse__Stage__c);
        AssignmentRollupHelper.isRunning=false;
        TriggerState.resetThisTrigger('x7sAssignmentTrigger');
        update assignment;
        Test.stopTest();
        System.debug('---------------- TEST COMPLETED ----------------');
    } 
   
    @isTest static void testCompletedNB() {
        EstVsActualsRollupHelper.isRunning=true;
        pse__Assignment__c assignment = [SELECT Id, pse__Project__c, pse__is_billable__c, pse__Bill_Rate__c FROM pse__Assignment__c LIMIT 1];
        pse__Proj__c project = [SELECT Id, pse__Stage__c FROM pse__Proj__c WHERE Id =: assignment.pse__Project__c];
        Test.startTest();
        project.pse__Stage__c='Completed';
        update project;
        assignment.pse__is_billable__c=false;
        assignment.pse__Bill_Rate__c=0.0;
        update assignment;
        Test.stopTest();
    } 
    
    @isTest static void testBuildNB() {
        EstVsActualsRollupHelper.isRunning=true;
        pse__Assignment__c assignment = [SELECT Id, pse__Project__c, pse__is_billable__c, pse__Bill_Rate__c FROM pse__Assignment__c LIMIT 1];
        pse__Proj__c project = [SELECT Id, pse__Stage__c FROM pse__Proj__c WHERE Id =: assignment.pse__Project__c];
        Test.startTest();
        project.pse__Stage__c='Build';
        update project;
        assignment.pse__is_billable__c=false;
        assignment.pse__Bill_Rate__c=0.0;
        update assignment;
        Test.stopTest();
    } 

}