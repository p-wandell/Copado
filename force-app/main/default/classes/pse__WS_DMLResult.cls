/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WS_DMLResult {
    webService Id dmlRecordID {
        get;
    }
    webService List<pse.WS_DMLResult.WS_DMLError> errors {
        get;
    }
    webService Boolean isCreated {
        get;
    }
    webService Boolean isSuccess {
        get;
    }
    global WS_DMLResult() {

    }
global class WS_DMLError {
    webService String errorMessage {
        get;
    }
    webService String errorStatusCode {
        get;
    }
    global WS_DMLError() {

    }
}
}
