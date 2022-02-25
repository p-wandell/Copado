/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class APIActualsService {
    global APIActualsService() {

    }
    global static pse.APICommonsService.BatchStatus ProcessTransactionDeltas() {
        return null;
    }
    global static pse.APICommonsService.BatchStatus RecalcProjectActualsByProjects(pse.APIActualsService.ActualsContextRecalcProjectActualsByProjects ac) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus RecalcProjectActualsWithActualsNeedsRecalc(pse.APIActualsService.ActualsContextRecalcProjectActualsWithActualsNeedsRecalc ac) {
        return null;
    }
global class ActualsContextRecalcProjectActualsByProjects extends pse.APICommonsService.BatchContext {
    global Set<Id> projectIDs;
    global ActualsContextRecalcProjectActualsByProjects() {

    }
}
global class ActualsContextRecalcProjectActualsWithActualsNeedsRecalc extends pse.APICommonsService.BatchContext {
    global Id accountID;
    global Id groupID;
    global Id practiceID;
    global Id regionID;
    global ActualsContextRecalcProjectActualsWithActualsNeedsRecalc() {

    }
}
}
