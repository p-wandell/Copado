/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TeamScheduleService {
    global TeamScheduleService() {

    }
    global Set<Id> createCustomTeamSchedule(Id teamId, List<pse.TeamScheduleService.CreateCustomTeamScheduleRequest> createCustomTeamScheduleRequest) {
        return null;
    }
    global Set<Id> createTeamScheduleFromTemplate(Id teamId, List<pse.TeamScheduleService.CreateTeamScheduleFromTemplateRequest> createTeamScheduleFromTemplateRequest) {
        return null;
    }
global class CreateCustomTeamScheduleRequest extends pse.TeamScheduleService.CreateTeamScheduleRequest {
    global String effectiveDate;
    global List<pse.TeamScheduleService.TeamScheduleSlotDetail> Slots;
    global String teamId;
    global CreateCustomTeamScheduleRequest(Id teamId, Date effectiveDate, List<pse.TeamScheduleService.TeamScheduleSlotDetail> slots) {

    }
}
global class CreateTeamScheduleFromTemplateRequest extends pse.TeamScheduleService.CreateTeamScheduleRequest {
    global String effectiveDate;
    global List<pse.TeamScheduleService.TeamScheduleSlotDetail> Slots;
    global String teamId;
    global Id TemplateId;
    global CreateTeamScheduleFromTemplateRequest(Id teamId, Date effectiveDate, Id templateId) {

    }
}
global abstract class CreateTeamScheduleRequest {
    global Date EffectiveDate;
    global Id TeamId;
}
global class TeamScheduleSlotDetail {
    global Integer Capacity;
    global String EndTime;
    global Decimal Hours;
    global String SlotName;
    global Id SlotType;
    global String StartTime;
    global TeamScheduleSlotDetail(String slotName, String startTime, String endTime, Decimal hours, Integer capacity, Id slotTypeId) {

    }
}
}
