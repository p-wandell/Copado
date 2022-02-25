/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TeamScheduleTemplateService {
    global TeamScheduleTemplateService() {

    }
    global Set<Id> createTeamScheduleTemplate(Id teamId, List<pse.TeamScheduleTemplateService.CreateTeamScheduleTemplateRequest> createTeamScheduleTemplateRequest) {
        return null;
    }
global class CreateTeamScheduleTemplateRequest extends pse.TeamScheduleTemplateService.TeamScheduleTemplateRequest {
    global List<pse.TeamScheduleTemplateService.TeamScheduleTemplateSlotDetail> Slots;
    global CreateTeamScheduleTemplateRequest(Id teamId, String templateName, List<pse.TeamScheduleTemplateService.TeamScheduleTemplateSlotDetail> slots) {

    }
}
global abstract class TeamScheduleTemplateRequest {
    global Id TeamId;
    global String TemplateName;
}
global class TeamScheduleTemplateSlotDetail {
    global Integer Capacity;
    global String EndTime;
    global Decimal Hours;
    global String SlotName;
    global Id SlotType;
    global String StartTime;
    global TeamScheduleTemplateSlotDetail(String slotName, String startTime, String endTime, Decimal hours, Integer capacity, Id slotTypeId) {

    }
}
}
