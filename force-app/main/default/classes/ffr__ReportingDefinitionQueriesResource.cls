/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/v1.0/definitions/*/queries')
global class ReportingDefinitionQueriesResource {
    global ReportingDefinitionQueriesResource() {

    }
    @HttpGet
    global static void doGet() {

    }
global class ExcelQuery {
    global Map<String,String> Columns;
    global String FFRRow;
    global String QueryString;
    global ExcelQuery() {

    }
}
global class QuerySet {
    global String DataRange;
    global List<String> GroupColumns;
    global String Message;
    global Map<String,String> NonAccessibleFields;
    global Map<String,String> NonAccessibleFilterFields;
    global List<String> OtherColumns;
    global List<ffr.ReportingDefinitionQueriesResource.ExcelQuery> Queries;
}
}
