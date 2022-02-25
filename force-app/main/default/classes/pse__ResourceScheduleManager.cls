/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ResourceScheduleManager {
    global ResourceScheduleManager() {

    }
    webService static pse.ResourceScheduleManager.ProposedSchedule calcScheduleByAdjustingDailyHours(Date startDate, Date endDate, Double totalHours, pse.ResourceScheduleManager.SchedulePattern schedPat, String resourceId) {
        return null;
    }
    webService static pse.ResourceScheduleManager.ProposedSchedule calcScheduleByAdjustingEndDate(Date startDate, Double totalHours, pse.ResourceScheduleManager.SchedulePattern schedPat, Boolean levelSchedule, String resourceId) {
        return null;
    }
global class ProjTaskAssignmentData {
    global ProjTaskAssignmentData() {

    }
}
global class ProposedSchedule {
    webService String resourceId {
        get;
        set;
    }
    webService pse__Schedule__c schedule {
        get;
        set;
    }
    webService List<pse__Schedule_Exception__c> scheduleExcList {
        get;
        set;
    }
    webService Double totalHours {
        get;
        set;
    }
}
global class SchedulePattern {
    webService Double fridayHours {
        get;
        set;
    }
    webService Double mondayHours {
        get;
        set;
    }
    webService Double saturdayHours {
        get;
        set;
    }
    webService Double sundayHours {
        get;
        set;
    }
    webService Double thursdayHours {
        get;
        set;
    }
    webService Double tuesdayHours {
        get;
        set;
    }
    webService Double wednesdayHours {
        get;
        set;
    }
}
}
