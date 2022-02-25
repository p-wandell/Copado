public class RisksAndIssuesInvokable {
	@InvocableMethod(label='Set Project Status' description='Update the project control borad status fields on the project record')
    public static void updateProjectStatusFields(List<Risks_Issues__c> risks) {
        RiskAndIssuesStatusHandler.setProjectRecordStatus(risks);
    }
}