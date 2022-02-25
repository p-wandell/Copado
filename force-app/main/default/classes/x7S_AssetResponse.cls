public with sharing class x7S_AssetResponse extends Peak_Response{
    @AuraEnabled public List<String> labels{get;set;} // custom results to iterate over - use this when creating a list of custom wrapper classes

    public x7S_AssetResponse(){
        super();
        labels = new List<String>();
    }
}