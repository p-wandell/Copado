/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ConfigWebService {
    global ConfigWebService() {

    }
    webService static List<pse.ConfigWebService.DescribeConfig> describeConfigsBasic(List<String> groupKeys) {
        return null;
    }
    webService static List<pse.ConfigWebService.DescribeConfig> describeConfigs(List<String> groupKeys, String defaultFieldReferenceContextName) {
        return null;
    }
global class DescribeCommon {
    @WebService
    webService String label;
    @WebService
    webService String name;
    global DescribeCommon() {

    }
}
global class DescribeConfig {
    @WebService
    webService pse.ConfigWebService.DescribeCommon common;
    @WebService
    webService Boolean multiValue;
    @WebService
    webService List<String> picklist;
    @WebService
    webService List<pse.ConfigWebService.DescribeFieldReference> referenceValues;
    @WebService
    webService String type;
    @WebService
    webService List<String> values;
    global DescribeConfig() {

    }
}
global class DescribeFieldReference {
    @WebService
    webService List<pse.ConfigWebService.DescribeCommon> chain;
    @WebService
    webService Boolean multiReference;
    @WebService
    webService List<pse.ConfigWebService.DescribeCommon> picklist;
    @WebService
    webService List<pse.ConfigWebService.DescribeCommon> referenceTo;
    @WebService
    webService String type;
    global DescribeFieldReference() {

    }
}
}
