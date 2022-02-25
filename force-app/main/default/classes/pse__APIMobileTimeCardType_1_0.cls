/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class APIMobileTimeCardType_1_0 {
    global APIMobileTimeCardType_1_0() {

    }
global class AssignmentInfo {
    @WebService
    webService String accountName;
    @WebService
    webService Id assignmentId;
    @WebService
    webService Decimal billableHours;
    @WebService
    webService Decimal estimatedHours;
    @WebService
    webService Boolean globalAssignment;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Boolean isDisable;
    @WebService
    webService String nickName;
    @WebService
    webService Id projectId;
    @WebService
    webService String projectName;
    @WebService
    webService Decimal scheduledHours;
    global AssignmentInfo() {

    }
}
global class CustomLabelInfo {
    @WebService
    webService String labelName;
    @WebService
    webService String labelValue;
    global CustomLabelInfo() {

    }
}
global class MilestoneInfo {
    @WebService
    webService Id milestoneId;
    @WebService
    webService String milestoneName;
    global MilestoneInfo() {

    }
}
global class ProjectLocation {
    @WebService
    webService Id locationId;
    @WebService
    webService String name;
    global ProjectLocation() {

    }
}
global class ProjectMethodology {
    @WebService
    webService Id methodologyId;
    @WebService
    webService String name;
    global ProjectMethodology() {

    }
}
global class ProjectPhase {
    @WebService
    webService String name;
    @WebService
    webService Id phaseId;
    global ProjectPhase() {

    }
}
global class TimeCardDetailInfo {
    @WebService
    webService List<pse.APIMobileTimeCardType_1_0.TimecardAdditionalFields> additionalFields;
    @WebService
    webService Id assignmentId;
    @WebService
    webService String assignmentName;
    @WebService
    webService Date endDate;
    @WebService
    webService Decimal estimatedTime;
    @WebService
    webService Decimal fridayHours;
    @WebService
    webService String fridayLocation;
    @WebService
    webService String fridayNotes;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Boolean isDisableBillable;
    @WebService
    webService Boolean isHolidayOnFriday;
    @WebService
    webService Boolean isHolidayOnMonday;
    @WebService
    webService Boolean isHolidayOnSaturday;
    @WebService
    webService Boolean isHolidayOnSunday;
    @WebService
    webService Boolean isHolidayOnThursday;
    @WebService
    webService Boolean isHolidayOnTuesday;
    @WebService
    webService Boolean isHolidayOnWednesday;
    @WebService
    webService Boolean isTravellingOnFriday;
    @WebService
    webService Boolean isTravellingOnMonday;
    @WebService
    webService Boolean isTravellingOnSaturday;
    @WebService
    webService Boolean isTravellingOnSunday;
    @WebService
    webService Boolean isTravellingOnThursday;
    @WebService
    webService Boolean isTravellingOnTuesday;
    @WebService
    webService Boolean isTravellingOnWednesday;
    @WebService
    webService Id milestoneId;
    @WebService
    webService String milestoneName;
    @WebService
    webService Decimal mondayHours;
    @WebService
    webService String mondayLocation;
    @WebService
    webService String mondayNotes;
    @WebService
    webService Id projectId;
    @WebService
    webService Id projectLocationFri;
    @WebService
    webService String projectLocationFriName;
    @WebService
    webService Id projectLocationMon;
    @WebService
    webService String projectLocationMonName;
    @WebService
    webService Id projectLocationSat;
    @WebService
    webService String projectLocationSatName;
    @WebService
    webService Id projectLocationSun;
    @WebService
    webService String projectLocationSunName;
    @WebService
    webService Id projectLocationThu;
    @WebService
    webService String projectLocationThuName;
    @WebService
    webService Id projectLocationTue;
    @WebService
    webService String projectLocationTueName;
    @WebService
    webService Id projectLocationWed;
    @WebService
    webService String projectLocationWedName;
    @WebService
    webService String projectMethodolgyName;
    @WebService
    webService Id projectMethodology;
    @WebService
    webService String projectName;
    @WebService
    webService Id projectPhase;
    @WebService
    webService String projectPhaseName;
    @WebService
    webService Id resourceId;
    @WebService
    webService Decimal saturdayHours;
    @WebService
    webService String saturdayLocation;
    @WebService
    webService String saturdayNotes;
    @WebService
    webService Date startDate;
    @WebService
    webService String startDay;
    @WebService
    webService String status;
    @WebService
    webService Decimal sundayHours;
    @WebService
    webService String sundayLocation;
    @WebService
    webService String sundayNotes;
    @WebService
    webService Decimal thursdayHours;
    @WebService
    webService String thursdayLocation;
    @WebService
    webService String thursdayNotes;
    @WebService
    webService Id timeCardHeader;
    @WebService
    webService String timecardMethodology;
    @WebService
    webService String timecardPhase;
    @WebService
    webService Decimal totalHoursWorked;
    @WebService
    webService Decimal tuesdayHours;
    @WebService
    webService String tuesdayLocation;
    @WebService
    webService String tuesdayNotes;
    @WebService
    webService Decimal wednesdayHours;
    @WebService
    webService String wednesdayLocation;
    @WebService
    webService String wednesdayNotes;
    @WebService
    webService String weeklyNotes;
    global TimeCardDetailInfo() {

    }
}
global class TimeCardDetailLabels {
    @WebService
    webService String labelName;
    @WebService
    webService String labelValue;
    global TimeCardDetailLabels() {

    }
}
global class TimeCardHeaderInfo {
    @WebService
    webService Date endDate;
    @WebService
    webService Boolean isMissingTimeCard;
    @WebService
    webService String status;
    @WebService
    webService Decimal totalHours;
    @WebService
    webService Decimal totalWorkedDays;
    global TimeCardHeaderInfo() {

    }
}
global class TimecardAdditionalFields {
    @WebService
    webService Decimal decimalScale;
    @WebService
    webService String fieldLabel;
    @WebService
    webService String fieldName;
    @WebService
    webService String fieldType;
    @WebService
    webService String fieldValue;
    @WebService
    webService Boolean isInsertable;
    @WebService
    webService Boolean isUpdateable;
    global TimecardAdditionalFields() {

    }
}
global class TimecardConfig {
    @WebService
    webService String configName;
    @WebService
    webService String configValue;
    global TimecardConfig() {

    }
}
global class TimecardLabelsAndSettings {
    @WebService
    webService List<pse.APIMobileTimeCardType_1_0.TimecardAdditionalFields> additionalFields;
    @WebService
    webService List<pse.APIMobileTimeCardType_1_0.TimeCardDetailLabels> detailLabels;
    @WebService
    webService List<pse.APIMobileTimeCardType_1_0.TimecardConfig> timecardConfigs;
    global TimecardLabelsAndSettings() {

    }
}
global class WeekEndingInfo {
    @WebService
    webService Boolean isHolidayOnFriday;
    @WebService
    webService Boolean isHolidayOnMonday;
    @WebService
    webService Boolean isHolidayOnSaturday;
    @WebService
    webService Boolean isHolidayOnSunday;
    @WebService
    webService Boolean isHolidayOnThursday;
    @WebService
    webService Boolean isHolidayOnTuesday;
    @WebService
    webService Boolean isHolidayOnWednesday;
    @WebService
    webService String startDay;
    @WebService
    webService Decimal totalWorkHours;
    global WeekEndingInfo() {

    }
}
}
