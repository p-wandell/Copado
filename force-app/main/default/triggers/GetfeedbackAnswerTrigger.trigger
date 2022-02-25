trigger GetfeedbackAnswerTrigger on GetFeedback_Aut__Answer__c (after insert, after update, after delete) {
    
    System.debug('-------- trigger.size: ' + trigger.size);
    
    switch on Trigger.operationType {
        when AFTER_INSERT {
            System.debug('-------- trigger.new.size(): ' + trigger.new.size());
            GetfeedbackAnswerTriggerHandler.OnAfterInsert(trigger.newMap);
            GetfeedbackAnswerTriggerHandler.m_isExecuting = true;
        }
        
        when AFTER_UPDATE {
            System.debug('-------- trigger.new.size(): ' + trigger.new.size());
            GetfeedbackAnswerTriggerHandler.OnAfterInsert(trigger.newMap);
            GetfeedbackAnswerTriggerHandler.m_isExecuting = true;
        }
        
        when AFTER_DELETE {
            GetfeedbackAnswerTriggerHandler.OnAfterDelete(trigger.oldMap);
            GetfeedbackAnswerTriggerHandler.m_isExecuting = true;
        }
    }
    
}