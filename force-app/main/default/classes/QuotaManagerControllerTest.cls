@isTest
public with sharing class QuotaManagerControllerTest {
	
	@IsTest(SeeAllData=true)
	public static void testController(){
		User forecastingUser = [SELECT Id FROM User WHERE IsActive=true AND ForecastEnabled = true LIMIT 1];
		
		QuotaManagerController ctrlr = new QuotaManagerController();
		Integer size = ctrlr.Quotas.size();
		
		ctrlr.addNew();
		
		System.assert(ctrlr.Quotas != null);
		System.assert(ctrlr.Quotas.size() == size+1);
		
	 	ctrlr.Quotas[size].QuotaAmount = 100.0;
	 	ctrlr.Quotas[size].QuotaOwnerId = forecastingUser.Id;
	 	// M Hemphill - I had to update this date to the new year to get this test class to work.  
	 	//              Not sure what the purpose is, I'm just trying to load some apex classes/VF pages.
	 	//              Should work going forward.
	 	//ctrlr.Quotas[size].StartDate = Date.newInstance(2015,1,1);
	 	ctrlr.Quotas[size].StartDate = Date.newInstance(Date.today().year(),1,1);
	 	
	 	ctrlr.saveForm();
	 	
	 	System.assert(ctrlr.Quotas != null);
		System.assert(ctrlr.Quotas.size() == size+1);
		
		ctrlr.DeleteId = ctrlr.Quotas[size].Id;
		
		ctrlr.deleteForm();
		
		System.assert(ctrlr.Quotas == null || ctrlr.Quotas.size() == size);
	}
}