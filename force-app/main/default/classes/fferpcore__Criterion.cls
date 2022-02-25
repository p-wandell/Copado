/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class Criterion extends fferpcore.PluginTool.Plugin implements fferpcore.PublicationMatcher, fferpcore.SubscriptionMatcher {
    global Criterion() {

    }
    global static fferpcore.Criterion All(List<fferpcore.Criterion> criteria) {
        return null;
    }
    global static fferpcore.Criterion Contains(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion EndsWith(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion Equal(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion GreaterThan(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion GreaterThanEqual(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion Invert(fferpcore.Criterion criterion) {
        return null;
    }
    global static fferpcore.Criterion LessThan(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion LessThanEqual(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion NotContains(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion NotEqual(fferpcore.Path path, Object value) {
        return null;
    }
    global static fferpcore.Criterion Some(List<fferpcore.Criterion> criteria) {
        return null;
    }
    global static fferpcore.Criterion StartsWith(fferpcore.Path path, Object value) {
        return null;
    }
    global abstract String getName();
    global abstract Boolean matches(fferpcore.DataSource.Row param0);
    global abstract Boolean matches(fferpcore.DeliveredMessage param0);
    global abstract void prepare(fferpcore.DataSource param0);
global abstract class Composite extends fferpcore.Criterion {
    global Composite(List<fferpcore.Criterion> criteria) {

    }
    global abstract String getConnector();
    global List<fferpcore.Criterion> getCriteria() {
        return null;
    }
}
global abstract class Simple extends fferpcore.Criterion {
    global Simple(fferpcore.Path path, Object value) {

    }
    global abstract String getLabel();
    global fferpcore.Path getPath() {
        return null;
    }
    global Object getValue() {
        return null;
    }
    global abstract Boolean matches(Object param0, Object param1);
}
global abstract class Single extends fferpcore.Criterion {
    global Single(fferpcore.Criterion criterion) {

    }
    global fferpcore.Criterion getCriterion() {
        return null;
    }
    global abstract String getKeyword();
}
}
