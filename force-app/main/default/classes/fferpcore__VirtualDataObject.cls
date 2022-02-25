/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class VirtualDataObject {
    global VirtualDataObject() {

    }
global interface Accessible {
    Boolean hasCreateAccess();
    Boolean hasDeleteAccess();
    Boolean hasEditAccess();
    Boolean hasReadAccess();
    Boolean supportsWrite();
}
global interface ChildRelationshipDescribe extends fferpcore.VirtualDataObject.DescribeBase {
    fferpcore.VirtualDataObject.ObjectDescribe getTarget();
}
global interface CommitResult {
    String getRecordId();
    Boolean isSuccess();
}
global interface Consumer {
    void consume(fferpcore.VirtualDataObject.RecordList param0);
    void prepare(fferpcore.VirtualDataObject.Provider param0);
}
global interface ErrorEvent {
    String getErrorKey();
    fferpcore.Path2.TargetType getErrorPathTargetType();
    fferpcore.VirtualDataObject.Record getErrorRecord();
    String getMessage();
    fferpcore.Path2.Element getPath();
    fferpcore.VirtualDataObject.Record getRootRecord();
}
global interface ErrorListener {
    Boolean equals(Object param0);
    Integer hashCode();
    void onError(fferpcore.VirtualDataObject.ErrorEvent param0);
}
global interface FieldDescribe extends fferpcore.VirtualDataObject.DescribeBase {
    fferpcore.DataType getDataType();
}
global interface LookupDescribe extends fferpcore.VirtualDataObject.DescribeBase {
    fferpcore.VirtualDataObject.ObjectDescribe getTarget();
}
global interface ObjectDescribe extends fferpcore.VirtualDataObject.Accessible {
    Map<String,fferpcore.VirtualDataObject.ChildRelationshipDescribe> getChildRelationships();
    Map<String,fferpcore.VirtualDataObject.FieldDescribe> getFields();
    Map<String,fferpcore.VirtualDataObject.LookupDescribe> getLookups();
    String getObjectName();
}
global interface PreparableSource {
    fferpcore.VirtualDataObject.ObjectDescribe describe();
    fferpcore.VirtualDataObject.PreparableSource requireChildren(String param0, fferpcore.Intent param1);
    void requireField(String param0, fferpcore.Intent param1);
    fferpcore.VirtualDataObject.PreparableSource requireLookup(String param0, fferpcore.Intent param1);
}
global interface Provider extends fferpcore.VirtualDataObject.PreparableSource {
    void addError(String param0);
    void addErrorListener(fferpcore.VirtualDataObject.ErrorListener param0);
    void addSourceErrorListener(fferpcore.VirtualDataObject.ErrorListener param0);
    fferpcore.VirtualDataObject.WorkScope createWorkScope();
    fferpcore.VirtualDataObject.RecordList getRecords();
}
global interface ProviderFactory {
    fferpcore.VirtualDataObject.Provider createProvider(Set<String> param0, fferpcore.SharingModel param1);
    void init(fferpcore.VirtualDataObject.ProviderKey param0, String param1);
    Boolean ownsRecord(String param0);
}
global class ProviderKey implements fferpcore.ObjectIO.ActivatableObject2 {
    global ProviderKey(String virtualDataObjectName, String providerName) {

    }
    global String getProviderName() {
        return null;
    }
    global String getVirtualDataObjectName() {
        return null;
    }
}
global interface Record {
    void addError(String param0, String param1);
    void addErrorListener(fferpcore.VirtualDataObject.ErrorListener param0);
    Object get(String param0);
    fferpcore.VirtualDataObject.RecordList getChildRecords(String param0);
    String getId();
    fferpcore.VirtualDataObject.Record getLookupRecord(String param0);
    fferpcore.OptionalValue getLookupRecordOptional(String param0);
    fferpcore.OptionalValue getOptional(String param0);
    Boolean hasError();
    void put(String param0, Object param1);
}
global interface RecordList extends System.Iterable {
    void addError(String param0);
    void addErrorListener(fferpcore.VirtualDataObject.ErrorListener param0);
    fferpcore.VirtualDataObject.Record create();
    void destroyAll();
    fferpcore.VirtualDataObject.Record get(Integer param0);
    Integer size();
}
global interface SObjectRecord extends fferpcore.VirtualDataObject.Record {
    SObject getSObject();
}
global interface WorkScope extends fferpcore.Disposable {
    Map<String,fferpcore.VirtualDataObject.CommitResult> commitPendingWork(fferpcore.Atomicity param0);
}
}
