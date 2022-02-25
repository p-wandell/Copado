/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CompanyService {
    global static fferpcore.CompanyService.AddTaxInformationResponse addTaxInformation(List<fferpcore.CompanyService.AddTaxInformationRequest> requests) {
        return null;
    }
    global static List<fferpcore.CompanyService.CompanySummary> loadCompaniesWithoutTaxInformation() {
        return null;
    }
global class AddTaxInformationRequest {
    global Id CompanyId {
        get;
        set;
    }
    global Id TaxInformationId {
        get;
        set;
    }
    global AddTaxInformationRequest() {

    }
    global AddTaxInformationRequest(Id companyId, Id taxInformationId) {

    }
}
global class AddTaxInformationResponse {
    global AddTaxInformationResponse() {

    }
}
global class CompanySummary {
    global Id Id {
        get;
    }
    global String Name {
        get;
    }
    global CompanySummary(Id id, String name) {

    }
}
}
