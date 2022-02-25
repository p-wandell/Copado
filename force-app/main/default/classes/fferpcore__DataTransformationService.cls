/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DataTransformationService {
    global DataTransformationService() {

    }
    global static fferpcore.DataTransformationService.TransformResult transform(Set<fferpcore.DataTransformationService.TransformRequest> requests) {
        return null;
    }
global class DataResult {
    global DataResult(String output, String error) {

    }
    global String getError() {
        return null;
    }
    global String getOutput() {
        return null;
    }
    global Boolean isError() {
        return null;
    }
}
global class TransformRequest {
    global TransformRequest(Id transformTableId, List<String> inputs) {

    }
    global Boolean equals(Object other) {
        return null;
    }
    global List<String> getInputs() {
        return null;
    }
    global Id getTransformTableId() {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class TransformResult {
    global TransformResult(Map<fferpcore.DataTransformationService.TransformRequest,fferpcore.DataTransformationService.DataResult> requestToResultMap) {

    }
    global fferpcore.DataTransformationService.DataResult getDataResultForTransformRequest(fferpcore.DataTransformationService.TransformRequest transformRequest) {
        return null;
    }
}
}
