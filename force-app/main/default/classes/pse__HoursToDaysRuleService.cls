/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class HoursToDaysRuleService {
    global HoursToDaysRuleService() {

    }
global class HoursToDaysRuleCalculation {
    global Decimal fridayDays;
    global Decimal fridayHours;
    global Decimal mondayDays;
    global Decimal mondayHours;
    global pse__Hours_to_Days_Rule__c rule;
    global Decimal saturdayDays;
    global Decimal saturdayHours;
    global Decimal sundayDays;
    global Decimal sundayHours;
    global Decimal thursdayDays;
    global Decimal thursdayHours;
    global Decimal tuesdayDays;
    global Decimal tuesdayHours;
    global Decimal wednesdayDays;
    global Decimal wednesdayHours;
    global HoursToDaysRuleCalculation() {

    }
    global Decimal getTotalDays() {
        return null;
    }
}
global interface IHoursToDaysRulePlugin {
    void calculate(pse.HoursToDaysRuleService.HoursToDaysRuleCalculation param0);
}
global class RoundUpFirstOnDaysClosestToBillableThresholds implements pse.HoursToDaysRuleService.IHoursToDaysRulePlugin {
    global RoundUpFirstOnDaysClosestToBillableThresholds() {

    }
    global void calculate(pse.HoursToDaysRuleService.HoursToDaysRuleCalculation calc) {

    }
}
}
