/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FeatureConsoleUpdateWithOptions {
    global static String LIGHTNING_APP;
    global static String LIGHTNING_COMPONENT;
    global FeatureConsoleUpdateWithOptions() {

    }
global class DisplayData {
    global String CurrentColumnHeaderText {
        get;
        set;
    }
    global List<String> Errors {
        get;
        set;
    }
    global Boolean HasNothingToDo {
        get;
        set;
    }
    global String HeaderText {
        get;
        set;
    }
    global Boolean IsRevert {
        get;
        set;
    }
    global List<fferpcore.FeatureConsoleUpdateWithOptions.DisplayItem> Items {
        get;
        set;
    }
    global String NameColumnHeaderText {
        get;
        set;
    }
    global String ProposedColumnHeaderText {
        get;
        set;
    }
    global Boolean ShowCurrentColumn {
        get;
        set;
    }
    global String Title {
        get;
        set;
    }
    global DisplayData() {

    }
    global String serialize() {
        return null;
    }
}
global class DisplayItem {
    global String ApiKey {
        get;
        set;
    }
    global String CurrentValue {
        get;
        set;
    }
    global String DisplayKey {
        get;
        set;
    }
    global String ProposedValue {
        get;
        set;
    }
    global Boolean Selected {
        get;
        set;
    }
    global DisplayItem() {

    }
    global DisplayItem(String key) {

    }
    global fferpcore.FeatureConsoleUpdateWithOptions.DisplayItem withCurrentValue(String value) {
        return null;
    }
    global fferpcore.FeatureConsoleUpdateWithOptions.DisplayItem withProposedValue(String value) {
        return null;
    }
    global fferpcore.FeatureConsoleUpdateWithOptions.DisplayItem withSelected(Boolean value) {
        return null;
    }
}
}
