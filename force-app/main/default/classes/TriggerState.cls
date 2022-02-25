/***************************************************************************
//
// Description    : Class that returns the state of a given trigger and
//                : if it should execute when test methods are executed
//                  
// Jul 24, 2020   : Randy Wandell   Original  
//   
//***************************************************************************/
public class TriggerState {
    public static TriggerSettings__c triggerSetting;
    
    public static boolean isActive {get; set;}
    public static boolean isTestMode {get; set;}
    public static boolean isBeforeInsert {get; set;}
    public static boolean isAfterInsert {get; set;}
    public static boolean isBeforeUpdate {get; set;}
    public static boolean isAfterUpdate {get; set;}
    public static boolean isBeforeDelete {get; set;}
    public static boolean isAfterDelete {get; set;}
    public static boolean isAfterUnDelete {get; set;}
    public static boolean isRunning = false;
    
    private static Map<String, boolean> activeTriggerMap = new Map<String, boolean>();
    private static List<TriggerSettings__c> settings;
    
    public static boolean isActive(SObjectType objectType) {
        System.debug('******** ' + objectType + ' ********');
        String objectName = '' + objectType;
        
        if(triggerSetting == null) {
            try {
                triggerSetting = [SELECT Id, ObjectName__c, TriggerName__c, IsActive__c, IsTestMode__c, IsBeforeInsert__c, IsAfterInsert__c, 
                                  IsBeforeUpdate__c, IsAfterUpdate__c, IsBeforeDelete__c, IsAfterDelete__c, IsAfterUndelete__c
                                  FROM TriggerSettings__c WHERE ObjectName__c =: objectName ORDER BY TriggerName__c];
                settings = new List<TriggerSettings__c>();
                settings.add(triggerSetting);
            } catch (Exception e) {
                System.debug('******** Exception caught ********');
                triggerSetting = addTriggerToSettings(objectName, null);
                System.debug('triggerSetting: ' + triggerSetting);
            }
            
            System.debug('****** before setValues ********');
            setValues(null);
            
            if(triggerSetting.IsActive__c == null) { isActive = false; }
            
            if(Test.isRunningTest()) {
                if(triggerSetting.IsTestMode__c == null) { isTestMode = false; }
                isActive = isTestMode;
            }
        }
        
        System.debug('******* returning ' + isActive + ' ********');
        return isActive;
    }
    
    public static boolean isActive(SObjectType objectType, String triggerName) {
        System.debug('******** ' + objectType + ' ********    ******** ' + triggerName + ' ********');
        String objectName = '' + objectType;
        
        if(triggerSetting == null) {
            try {
                settings = [SELECT Id, ObjectName__c, TriggerName__c, IsActive__c, IsTestMode__c, IsBeforeInsert__c, IsAfterInsert__c, 
                            IsBeforeUpdate__c, IsAfterUpdate__c, IsBeforeDelete__c, IsAfterDelete__c, IsAfterUndelete__c
                            FROM TriggerSettings__c WHERE ObjectName__c =: objectName ORDER BY TriggerName__c];
                if(settings.isEmpty()) { triggerSetting = addTriggerToSettings(objectName, triggerName); }
            } catch (Exception e) {
                System.debug('******** Exception caught ********');
                triggerSetting = addTriggerToSettings(objectName, triggerName);
                System.debug('triggerSetting: ' + triggerSetting);
            }
            
            System.debug('****** before setValues ********');
            setValues(triggerName);
            
            if(triggerSetting.IsActive__c == null) { isActive = false; }
            
            if(Test.isRunningTest()) {
                if(triggerSetting.IsTestMode__c == null) { isTestMode = false; }
                isActive = isTestMode;
            }
        }
        
        System.debug('******* returning ' + isActive + ' ********');
        return isActive;
    }
    
    private static TriggerSettings__c addTriggerToSettings(String objectName, String triggerName) {
        AggregateResult ar = [SELECT COUNT(Id) recordCount FROM TriggerSettings__c];
        String name = 'TS-';
        String recordCount = ''+(Integer)ar.get('recordCount');
        name = name + '000000'.left(6-recordCount.length()) + recordCount;
        System.debug('-------- name: ' + name);
        
        TriggerSettings__c t = new TriggerSettings__c();
        t.Name = name;
        t.ObjectName__c = objectName;
        t.TriggerName__c = triggerName;
        t.isActive__c = true;
        t.isTestMode__c = true;
        t.isBeforeInsert__c = true;
        t.isAfterInsert__c = true;
        t.isBeforeUpdate__c = true;
        t.isAfterUpdate__c = true;
        t.isBeforeDelete__c = true;
        t.isAfterDelete__c = true;
        t.isAfterUnDelete__c = true;
        
        insert t;
        
        settings = new List<TriggerSettings__c>();
        settings.add(t);
        
        System.debug(t);
        return t;
    }
    
    private static void setValues(String triggerName) {
        for(TriggerSettings__c setting : settings) {
            System.debug('******** setting values ********');
            if(setting.TriggerName__c == null || setting.TriggerName__c == triggerName) {
                triggerSetting=setting;
                isActive = triggerSetting.isActive__c;
                isTestMode = triggerSetting.isTestMode__c;
                isBeforeInsert = triggerSetting.isBeforeInsert__c;
                isAfterInsert = triggerSetting.isAfterInsert__c;
                isBeforeUpdate = triggerSetting.isBeforeUpdate__c;
                isAfterUpdate = triggerSetting.isAfterUpdate__c;
                isBeforeDelete = triggerSetting.isBeforeDelete__c;
                isAfterDelete = triggerSetting.isAfterDelete__c;
                isAfterUnDelete = triggerSetting.isAfterUnDelete__c;
            }
        }
    }
    
    public static boolean thisTriggerIsRunning(String triggerName) {
        if(!activeTriggerMap.containsKey(triggerName)) {
            activeTriggerMap.put(triggerName, false);
        } 
//        else {
//            activeTriggerMap.get(triggerName);
//            activeTriggerMap.put(triggerName, true);
//        }
        return activeTriggerMap.get(triggerName);
    }
    
    public static void resetThisTrigger(String triggerName) {
        System.debug('---------- Resetting: ' + triggerName);
        System.debug(activeTriggerMap);
        activeTriggerMap.remove(triggerName);
        System.debug(activeTriggerMap);
    }
}