/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SchedulingStrategyService {
    global SchedulingStrategyService() {

    }
    global pse.SchedulingStrategyService.ProposedScheduleDetail prepareSchedule(pse.SchedulingStrategyService.ScheduleDetail scheduleDetail) {
        return null;
    }
    global Boolean reschedule(pse.SchedulingStrategyService.RescheduleWrapper request) {
        return null;
    }
    global Boolean reschedule(List<pse.SchedulingStrategyService.RescheduleWrapper> rescheduleWrapperList) {
        return null;
    }
    global pse__Assignment__c splitReschedule(pse.SchedulingStrategyService.SplitRescheduleWrapper request) {
        return null;
    }
    global List<pse__Assignment__c> splitReschedule(List<pse.SchedulingStrategyService.SplitRescheduleWrapper> splitRescheduleWrapperList) {
        return null;
    }
global class AdjustHoursScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global Boolean respectHoliday {
        get;
        set;
    }
    global Double scheduledHours {
        get;
        set;
    }
    global AdjustHoursScheduleDetail() {

    }
    global override virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
global class CustomScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global Double scheduledHours {
        get;
        set;
    }
    global pse.SchedulingStrategyService.SchedulePattern schedulePattern {
        get;
        set;
    }
    global CustomScheduleDetail() {

    }
    global override virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
global class EndDateLevelScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global Double scheduledHours {
        get;
        set;
    }
    global EndDateLevelScheduleDetail() {

    }
    global override virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
global interface ISchedulingStrategy {
    pse.SchedulingStrategyService.ProposedScheduleDetail prepareSchedule(pse.SchedulingStrategyService.ScheduleDetail param0);
}
global class IgnoreAvailabilityScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global Double scheduledHours {
        get;
        set;
    }
    global IgnoreAvailabilityScheduleDetail() {

    }
    global override virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
global class PercentAllocationRow {
    global Date endDate {
        get;
        set;
    }
    global Double percentAllocated {
        get;
        set;
    }
    global Date startDate {
        get;
        set;
    }
    global PercentAllocationRow() {

    }
}
global class PercentAllocationScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global List<pse.SchedulingStrategyService.PercentAllocationRow> percentAllocationRows {
        get;
        set;
    }
    global Boolean respectHoliday {
        get;
        set;
    }
    global PercentAllocationScheduleDetail() {

    }
    global override virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
global class ProposedScheduleDetail {
    global pse.SchedulingStrategyService.SchedulePattern schedule {
        get;
        set;
    }
    global List<pse.SchedulingStrategyService.SchedulePattern> scheduleExceptions {
        get;
        set;
    }
    global Double totalHours {
        get;
        set;
    }
    global ProposedScheduleDetail() {

    }
}
global class RescheduleWrapper {
    global pse.SchedulingStrategyService.ScheduleDetail scheduleDetail {
        get;
        set;
    }
    global Id scheduleId {
        get;
        set;
    }
    global RescheduleWrapper() {

    }
}
global abstract class ScheduleDetail {
    global Date endDate {
        get;
        set;
    }
    global Id resourceId {
        get;
        set;
    }
    global Date startDate {
        get;
        set;
    }
    global ScheduleDetail() {

    }
    global virtual Map<String,pse.SchedulingStrategyService.ScheduleDetailField> enumerateFields() {
        return null;
    }
    global virtual Object getField() {
        return null;
    }
    global virtual Object getField(String key) {
        return null;
    }
    global abstract System.Type resolveImplementation();
    global virtual void setField(String key, Object value) {

    }
}
global class ScheduleDetailField {
    global System.Type dataType;
    global Boolean isRequired;
    global String label;
    global String name;
    global ScheduleDetailField() {

    }
}
global class SchedulePattern {
    global Date endDate {
        get;
        set;
    }
    global Double fridayHours {
        get;
        set;
    }
    global Double mondayHours {
        get;
        set;
    }
    global Double saturdayHours {
        get;
        set;
    }
    global Date startDate {
        get;
        set;
    }
    global Double sundayHours {
        get;
        set;
    }
    global Double thursdayHours {
        get;
        set;
    }
    global Double tuesdayHours {
        get;
        set;
    }
    global Double wednesdayHours {
        get;
        set;
    }
    global SchedulePattern() {

    }
}
global class SplitRescheduleWrapper {
    global pse__Assignment__c assignment {
        get;
        set;
    }
    global Boolean markAssignmentAsClosedFlag {
        get;
        set;
    }
    global pse.SchedulingStrategyService.ScheduleDetail scheduleDetail {
        get;
        set;
    }
    global SplitRescheduleWrapper() {

    }
}
global class ZeroHourScheduleDetail extends pse.SchedulingStrategyService.ScheduleDetail {
    global ZeroHourScheduleDetail() {

    }
    global override System.Type resolveImplementation() {
        return null;
    }
}
}
