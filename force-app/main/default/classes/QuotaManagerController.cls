public without sharing class QuotaManagerController {
	public Id DeleteId {get;set;}
	public Integer SelectedYear {get;set;}
	public List<ForecastingQuota> Quotas {get;set;}
	public List<SelectOption> YearOptions {get;set;}

	public QuotaManagerController(){
		Integer currentYear = System.now().year();
		SelectedYear = currentYear;
		
		YearOptions = new List<SelectOption>();
		YearOptions.add(new SelectOption(currentYear + '', currentYear + ''));
		YearOptions.add(new SelectOption((currentYear + 1) + '', (currentYear + 1) + ''));
		
		initializeQuotas();
	}
	
	public void deleteForm(){
		ForecastingQuota toDelete = new ForecastingQuota();
		toDelete.Id = DeleteId;
		
		System.debug('QuotaManagerController.deleteForm: DeleteId=' + DeleteId);
		
		delete toDelete;
		
		initializeQuotas();
	}
	
	public void saveForm(){
		if( Quotas != null && Quotas.size() > 0 ){
			upsert Quotas;
		}
		
		initializeQuotas();
	}
	
	public void addNew(){
		if( Quotas == null ){
			Quotas = new List<ForecastingQuota>();
		}
		
		ForecastingQuota newQuota = new ForecastingQuota();
		newQuota.QuotaQuantity=0;
		newQuota.ForecastingTypeId = [SELECT Id FROM ForecastingType WHERE DeveloperName = 'OpportunityRevenue' LIMIT 1].Id;
		
		Quotas.add(newQuota);
	}
	
	public void initializeQuotas(){
		Boolean isThisYear = System.now().year() == SelectedYear;
		
		String soql = 'Select f.StartDate, f.QuotaOwnerId, f.QuotaAmount From ForecastingQuota f WHERE f.StartDate = ';
		
		if( isThisYear ){
			soql += 'THIS_YEAR';
		} else {
			soql += 'NEXT_YEAR';
		}
		
		soql += ' ORDER BY f.QuotaOwnerId, f.startDate ASC';
		
		Quotas = Database.query(soql);
	}
}