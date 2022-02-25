/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ActionCPFTOpportunities {
    @InvocableMethod(label='Create project from template and opportunity.' description='Create project from template and opportunity.')
    global static List<pse.ActionCPFTOpportunities.InvocableCreateProjectAPIResponse> createProjectsFromTemplatesAndOpportunities(List<pse.ActionCPFTOpportunities.InvocableCreateProjectAPIRequest> invocableOpportunityRequests) {
        return null;
    }
global class InvocableCreateProjectAPIRequest {
    @InvocableVariable(label='IsActive' description='Indicates if the cloned project is active.' required=false)
    global Boolean IsActive;
    @InvocableVariable(label='IsTemplate' description='Indicates if the cloned project is marked as a template.' required=false)
    global Boolean IsTemplate;
    @InvocableVariable(label='OpportunityId' description='The opportunity Id.' required=true)
    global Id OpportunityId;
    @InvocableVariable(label='ProjectName' description='Indicates the name of the cloned project.' required=false)
    global String ProjectName;
    @InvocableVariable(label='ProjectOwnerId' description='The project owner Id.' required=false)
    global Id ProjectOwnerId;
    @InvocableVariable(label='StartDate' description='The intended project start date. This is also used to calculate a date offset value to update other project and related object date fields.' required=true)
    global Date StartDate;
    @InvocableVariable(label='TemplateProjectId' description='The template project Id used as a template to create a new project.' required=true)
    global Id TemplateProjectId;
    @InvocableVariable(label='UseCurrentTimePeriod' description='Set to true to ensure the cloned project is in the current TimePeriod.' required=false)
    global Boolean UseCurrentTimePeriod;
    global InvocableCreateProjectAPIRequest() {

    }
}
global class InvocableCreateProjectAPIResponse {
    @InvocableVariable(label='Error' description='Stores exception messages that occur when executing methods from CreateProjectFromTemplateService.' required=false)
    global String ErrorString;
    @InvocableVariable(label='NewProjectId' description='The new cloned project Id.' required=false)
    global Id NewProjectId;
    @InvocableVariable(label='QueuedJobId' description='The CreateProjectFromTemplateService may spawn a Queueable to complete the work in a later transaction. When that happens, this is the Id of the AsyncApexJob that controls work. The record can be queried to monitor its status.' required=false)
    global Id QueuedJobId;
    global InvocableCreateProjectAPIResponse() {

    }
}
}
