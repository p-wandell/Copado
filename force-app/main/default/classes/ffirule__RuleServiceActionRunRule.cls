/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RuleServiceActionRunRule {
    global RuleServiceActionRunRule() {

    }
    @InvocableMethod(label='Run the ClickLink rule for the specified source records.' description='Run the ClickLink rule for the specified source records.')
    global static List<Id> runRule(List<ffirule.RuleServiceActionRunRule.RunRuleParameters> runRuleParams) {
        return null;
    }
global class RunRuleParameters {
    @InvocableVariable(label='Rule ID' description='Rule ID' required=true)
    global Id ruleId;
    @InvocableVariable(label='Source Object ID' description='Source Object ID' required=true)
    global Id sourceObjectId;
    global RunRuleParameters() {

    }
}
}
