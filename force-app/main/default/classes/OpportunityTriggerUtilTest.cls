@isTest
private class OpportunityTriggerUtilTest {
	@isTest static void testOpportunityUpdate() {
		App_Settings__c appSettings = new App_Settings__c();
		appSettings.Run_Opportunity_Trigger__c = true;
		insert appSettings;

		Account newAccount = new Account();
		newAccount.Name = 'Test Account';
		insert newAccount;

		Contact newContact = new Contact();
		newContact.FirstName = 'Test';
		newContact.LastName = 'Contact';
		newContact.AccountId = newAccount.Id;
		insert newContact;

		Solution_Offering__c newSolution = new Solution_Offering__c();
		newSolution.Name = 'Jive 7 Upgrade';
		newSolution.Contact_Role__c = newContact.Id;
		newSolution.Appointment_Date__c = Date.today();
		newSolution.Sold__c = false;
		newSolution.N_A__c = false;
		insert newSolution;

		Opportunity newOppty = new Opportunity();
		newOppty.Name = 'New Opportunity';
		newOppty.StageName = 'Identified';
        newOppty.Lead_Source__c='Sales Prospecting';
		newOppty.CloseDate = Date.today().addDays(60);
		newOppty.Project_Start_Date__c = Date.today();
		insert newOppty;

		newSolution.Opportunity__c = newOppty.Id;
		update newSolution;

		newOppty.StageName = 'Closed Won';
        newOppty.Description = 'Test Description';
        newOppty.Link_to_Final_Executed_SOW_PDF__c='https://google.com';
        newOppty.Solution_Primary_Audience__c='Customer';
		update newOppty;
	}

	@isTest static void testCreateSolutionOffering() {
		List<Solution_Offerring_Names__c> solutionRecords = new List<Solution_Offerring_Names__c>();
		solutionRecords.add(new Solution_Offerring_Names__c(Name = 'Jive 7 Upgrade', Use__c = true));
		solutionRecords.add(new Solution_Offerring_Names__c(Name = 'Social Marketing & Outreach', Use__c = true));
		solutionRecords.add(new Solution_Offerring_Names__c(Name = 'Box Resell', Use__c = true));
		solutionRecords.add(new Solution_Offerring_Names__c(Name = 'SFDC Community Workshop', Use__c = true));
		insert solutionRecords;

		Account newAccount = new Account();
		newAccount.Name = 'Test Account';
		insert newAccount;
		OpportunityTriggerUtil.createSolutionOfferingRecords();
	}
}