public without sharing class x7S_PTODashboardController {
    
    private List<X7STimeOffItem__mdt> timeOffItems {
        get {
            return [SELECT MasterLabel, Allocation__c FROM X7STimeOffItem__mdt ORDER BY Sequence__c];
        }
    }
    
    private Id contactId;
    
    public class TimeOffItem {
        public String itemName { get; set; }
        public Double hoursAllocated { get; set; }
        public Double hoursUsed { get; set; }
        public Double hoursScheduled { get; set; }
        public Double hoursRemaining { get; set; }
    }
    
    public List<TimeOffItem> timeoffItemDetails { get; set; }
    
    public x7S_PTODashboardController(ApexPages.StandardController stdController) {
        contactId=stdController.getId();
        Contact c = [SELECT pse__Start_Date__c FROM Contact WHERE Id=:contactId];
        timeoffItemDetails = new List<TimeOffItem>();
        System.debug(timeOffItems);
        if(!timeOffItems.isEmpty() && c.pse__Start_Date__c != null) {
            for(X7STimeOffItem__mdt toi : timeOffItems) {
                TimeOffItem ti = new TimeOffItem();
                ti.itemName = toi.MasterLabel;
                ti.hoursAllocated=toi.Allocation__c;
                Double startDayOfTheYear=c.pse__Start_Date__c.dayOfYear();
                Date apr1 = Date.newInstance(2021, 04, 01);
                Double divisor=365;
                if(c.pse__Start_Date__c.year()==System.today().year()) { 
                    
                    if(System.today().year()==2021 && c.pse__Start_Date__c>apr1) { 
                        divisor = divisor-apr1.dayOfYear();
                        startDayOfTheYear = startDayOfTheYear-apr1.dayOfYear();
                        
                        System.debug('---------> startDayOfTheYear: ' + startDayOfTheYear + '    ---------> divisor:' + divisor);

                        System.debug('---------> hoursAllocated: ' + ti.hoursAllocated);
                        ti.hoursAllocated=ti.hoursAllocated*(1-(startDayOfTheYear/divisor)); 
                    } else {
                        System.debug('---------> startDayOfTheYear: ' + startDayOfTheYear + '    ---------> divisor:' + divisor);
                        System.debug('---------> hoursAllocated: ' + ti.hoursAllocated);
                        //ti.hoursAllocated=ti.hoursAllocated*((365-startDayOfTheYear)/divisor);
                        ti.hoursAllocated=ti.hoursAllocated;

                    }
                } else {
                    ti.hoursAllocated=ti.hoursAllocated;
                }
                    
                ti.hoursUsed = getHoursForType(toi.MasterLabel, true);
                ti.hoursScheduled = getHoursForType(toi.MasterLabel, false);
                ti.hoursRemaining = ti.hoursAllocated-ti.hoursUsed-ti.hoursScheduled;
                if(ti.hoursRemaining<0.0) { ti.hoursRemaining=0.0; }
                timeoffItemDetails.add(ti);
            }
        }
        System.debug(timeoffItemDetails);
    }
    
    
    private double getHoursForType(String timeOffType, boolean used) {
        double hours=0.0;
        AggregateResult [] hoursForType;
        if(used) {
            Date integrationDate=Date.newInstance(2021, 4, 1);
            hoursForType = [SELECT SUM(pse__Total_Hours__c) TotalHours 
                            FROM pse__Timecard_Header__c 
                            WHERE pse__Resource__c=:contactId 
                            AND pse__Project__r.Name =: timeOffType
                            AND pse__Start_Date__c=THIS_YEAR
                            AND pse__Start_Date__c>=:integrationDate
                            AND pse__Start_Date__c<=TODAY];
        } else {
            hoursForType = [SELECT SUM(pse__Total_Hours__c) TotalHours 
                            FROM pse__Timecard_Header__c 
                            WHERE pse__Resource__c=:contactId 
                            AND pse__Project__r.Name =: timeOffType
                            AND pse__Start_Date__c=THIS_YEAR
                            AND pse__Start_Date__c>TODAY];
        }
        
        if(hoursForType != null && (Double)hoursForType[0].get('TotalHours') != null) { 
            hours = (Double)hoursForType[0].get('TotalHours'); 
        } else {
            hours=0.0;
        }
        
        return hours;
    }
}