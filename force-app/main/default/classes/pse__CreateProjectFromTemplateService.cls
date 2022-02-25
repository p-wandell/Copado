/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CreateProjectFromTemplateService {
    global static List<pse.CreateProjectFromTemplateService.CreateProjectResponse> createProjectsFromTemplates(List<pse.CreateProjectFromTemplateService.CreateProjectFromTemplateAndAccountRequest> requests) {
        return null;
    }
    global static List<pse.CreateProjectFromTemplateService.CreateProjectResponse> createProjectsFromTemplates(List<pse.CreateProjectFromTemplateService.CreateProjectFromTemplateAndOpportunityRequest> requests) {
        return null;
    }
    global static List<pse.CreateProjectFromTemplateService.CreateProjectResponse> createProjectsFromTemplates(List<pse.CreateProjectFromTemplateService.CreateProjectFromTemplateRequest> requests) {
        return null;
    }
global class CreateProjectError {
    global String Message;
}
global class CreateProjectFromTemplateAndAccountRequest extends pse.CreateProjectFromTemplateService.CreateProjectRequest {
    global Id AccountId;
    global CreateProjectFromTemplateAndAccountRequest(Id accountId, Id templateProjectId, Date startDate) {

    }
}
global class CreateProjectFromTemplateAndOpportunityRequest extends pse.CreateProjectFromTemplateService.CreateProjectRequest {
    global Id OpportunityId;
    global CreateProjectFromTemplateAndOpportunityRequest(Id opportunityId, Id templateProjectId, Date startDate) {

    }
}
global class CreateProjectFromTemplateRequest extends pse.CreateProjectFromTemplateService.CreateProjectRequest {
    global CreateProjectFromTemplateRequest(Id templateProjectId, Date startDate) {

    }
}
global abstract class CreateProjectRequest {
    global Boolean IsActive;
    global Boolean IsTemplate;
    global List<pse.SObjectCloneMapper> Mappers;
    global String ProjectName;
    global Id ProjectOwnerId;
    global Date StartDate;
    global Id TemplateProjectId;
    global Boolean UseCurrentTimePeriod;
}
global class CreateProjectResponse {
    global List<pse.CreateProjectFromTemplateService.CreateProjectError> Errors;
    global Id NewProjectId;
    global Id QueuedJobId;
    global pse.CreateProjectFromTemplateService.CreateProjectRequest Request;
    global Boolean isSuccess() {
        return null;
    }
}
}
