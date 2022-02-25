/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ResourceSearchService implements pse.ResourceSearchService.API {
    global ResourceSearchService() {

    }
    global static String debug() {
        return null;
    }
    global static List<Contact> execute(pse.ResourceSearchService.ResourceSearchFilter filter) {
        return null;
    }
global class Assignments {
    global Date endDate;
    global Set<String> fields;
    global Boolean includeBillable;
    global Boolean includeCredited;
    global Boolean includeExcluded;
    global Boolean includeExcludedFromPlanners;
    global Boolean includeNonbillable;
    global Boolean includeTeamAssignments;
    global Integer maxReturned;
    global Date startDate;
    global Assignments() {

    }
    global Assignments(Date startDate, Date endDate, Integer maxReturned) {

    }
    global Assignments(Date startDate, Date endDate, Integer maxReturned, Set<String> fields) {

    }
    global Assignments(Date startDate, Date endDate, Integer maxReturned, Boolean includeBillable, Boolean includeNonbillable, Boolean includeCredited, Boolean includeExcluded, Set<String> fields) {

    }
}
global class ResourceRequests {
    global Date endDate;
    global Set<String> fields;
    global Boolean includeExludedFromPlanners;
    global Boolean includeRequestsThatBecameAssignments;
    global Boolean includeRequestsWithoutSchedules;
    global Integer maxReturned;
    global Date startDate;
    global Boolean useScheduleDates;
    global ResourceRequests() {

    }
    global ResourceRequests(Date startDate, Date endDate, Integer maxReturned) {

    }
    global ResourceRequests(Date startDate, Date endDate, Integer maxReturned, Set<String> fields) {

    }
    global ResourceRequests(Date startDate, Date endDate, Integer maxReturned, Boolean includeRequestsWithoutSchedules, Boolean includeRequestsThatBecameAssignments, Set<String> fields) {

    }
}
global class ResourceSearchFilter {
    global List<pse.ResourceSearchService.ResourceSearchFilterField> additionalContactFilters;
    global List<pse.ResourceSearchService.SemiJoinFilter> additionalSemiJoinFilters;
    global Boolean applySecurityToReturnedData;
    global Boolean applySecurityToSearchCriteria;
    global Boolean applyStaffingPermissionControls;
    global pse.ResourceSearchService.Assignments assignments;
    global Boolean disableSecurityOnReturnedData;
    global Boolean disableSecurityOnSearchCriteria;
    global Boolean disableSharingModel;
    global Boolean elevateToWithoutSharing;
    global Datetime endTimeOfDay;
    global Set<String> fieldsToSelect;
    global Id groupFilter;
    global Set<Id> groupsFilter;
    global Boolean includeSubgroups;
    global Boolean includeSubpractices;
    global Boolean includeSubregions;
    global Boolean isAssigned;
    global Boolean isCalendared;
    global Boolean isHeld;
    global Integer maxReturnedResults;
    global List<String> orderByFields;
    global Id practiceFilter;
    global Set<Id> practicesFilter;
    global Id regionFilter;
    global Set<Id> regionsFilter;
    global pse.ResourceSearchService.ResourceRequests requests;
    global Set<Id> resourceIds;
    global List<List<pse.ResourceSearchService.SkillRating>> skillSets;
    global Set<Id> skillsToSelect;
    global Datetime startTimeOfDay;
    global Boolean utilizationAppliedConjunctionAnd;
    global Date utilizationEndDate;
    global Boolean utilizationIncludeBillableAssignments;
    global Boolean utilizationIncludeCreditedAssignments;
    global Boolean utilizationIncludeExcludedAssignments;
    global Boolean utilizationIncludeHeldResourceRequests;
    global Boolean utilizationIncludeNonBillableAssignments;
    global Decimal utilizationMinimumAvailability;
    global Decimal utilizationMinimumHoursAvailable;
    global Boolean utilizationNoMinimumAvailabilityRequirements;
    global Date utilizationStartDate;
    global ResourceSearchFilter() {

    }
}
global class ResourceSearchFilterField {
    global Schema.SObjectField field;
    global String operator;
    global Object value;
    global Set<Object> values;
    global ResourceSearchFilterField() {

    }
    global ResourceSearchFilterField(Schema.SObjectField field, Set<Object> values) {

    }
    global ResourceSearchFilterField(Schema.SObjectField field, String operator, Set<Object> values) {

    }
    global ResourceSearchFilterField(Schema.SObjectField field, String operator, Object value) {

    }
}
global class SemiJoinFilter {
    global Schema.SObjectType relatedObject;
    global Schema.SObjectField relationshipField;
    global Schema.SObjectField searchField;
    global Set<Id> values;
    global SemiJoinFilter() {

    }
    global SemiJoinFilter(Schema.SObjectType relatedObject, Schema.SObjectField relationshipField, Schema.SObjectField searchField, Set<Id> values) {

    }
}
global class SkillRating {
    global Schema.SObjectField alternativeRatingField;
    global Boolean matchGreaterThanRatings;
    global String operator;
    global String rating;
    global Id skillID;
    global SkillRating() {

    }
    global SkillRating(Id skillID, String rating) {

    }
    global SkillRating(Id skillID, String rating, Schema.SObjectField alternativeRatingField, Boolean matchGreaterThanRatings) {

    }
    global SkillRating(Id skillID, String rating, Schema.SObjectField alternativeRatingField, Boolean matchGreaterThanRatings, String operator) {

    }
}
}
