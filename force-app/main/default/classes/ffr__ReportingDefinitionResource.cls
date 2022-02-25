/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/v1.0/definitions/*')
global class ReportingDefinitionResource {
    global ReportingDefinitionResource() {

    }
    @HttpGet
    global static void doGet() {

    }
global virtual class Prompt {
    global Id Id;
    global String Name;
    global String Value;
    global Prompt() {

    }
}
global class PromptError extends ffr.ReportingDefinitionResource.Prompt {
    global String Error;
    global PromptError() {

    }
}
global class PromptPicklist extends ffr.ReportingDefinitionResource.Prompt {
    global Set<String> PicklistValues;
    global PromptPicklist() {

    }
}
global class ReportingDefinition {
    global String Description;
    global Id Id;
    global String Name;
    global List<ffr.ReportingDefinitionResource.Prompt> Prompts;
    global String Queries {
        get;
    }
    global String Title;
    global String Url {
        get;
    }
    global ReportingDefinition() {

    }
}
}
