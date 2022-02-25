/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ChildCorrelationStrategy {
    String getCorrelationKey();
    List<String> getCorrelationMessageKey();
    fferpcore.Intent getListIntent();
    void init(String param0, List<String> param1);
    void process(List<fferpcore.ChildCorrelationStrategyRequest> param0, fferpcore.TargetObjectList param1);
}
