public class ProjectStatisticsExtension {
    public class PhaseSummary {
        public String milestone { get; set; }
        public Date startDate { get; set; }
        public Date endDate { get; set; }
        public Decimal sowHours { get; set; }
        public Decimal sowDollars { get; set; }
        public Decimal estHours { get; set; }
        public Decimal estDollars { get; set; }
        public Decimal actualHours { get; set; }
        public Decimal actualDollars { get; set; }
        public Decimal etcHours { get; set; }
        public Decimal etcDollars { get; set; }
        public Decimal eacHours { get; set; }
        public Decimal eacDollars { get; set; }
        public Decimal varianceHours { get; set; }
        public Decimal varianceDollars { get; set; }
        public Decimal expenses { get; set; }
        
        public void init() {
            sowHours=0.0;
            sowDollars=0.0;
            estHours=0.0;
            estDollars=0.0;
            actualHours=0.0;
            actualDollars=0.0;
            etcHours=0.0;
            etcDollars=0.0;
            eacHours=0.0;
            eacDollars=0.0;
            varianceHours=0.0;
            varianceDollars=0.0;
            expenses=0.0;
        }
    }
    
    public pse__Proj__c project { get; set; }
    public List<PhaseSummary> phases { get; set; }
    public PhaseSummary nonBill { get; set; }
    public PhaseSummary projectTotals { get; set; }
    public Id projectId { get; set; }
    public PhaseSummary totals { get; set; }
    
    public ProjectStatisticsExtension(ApexPages.standardController standardController) {
        this.projectId = standardController.getId();
        this.project = [SELECT Id, pse__Start_Date__c, pse__End_Date__c, pse__Project_Id__c, pse__Stage__c FROM pse__Proj__c WHERE Id =: projectId];
        System.debug('-------- projectId: ' + projectId);
    }
    
    public List<PhaseSummary> getPhaseSummary() {
        
        phases = new List<PhaseSummary>();
        totals = new PhaseSummary();
        totals.milestone = 'Billable Totals';
        totals.init();
        
        nonBill = new PhaseSummary();
        nonBill.milestone = 'Non-Billable Totals';
        nonBill.init();
        
        projectTotals = new PhaseSummary();
        projectTotals.milestone = 'Project Totals';
        projectTotals.init();
        
        List<pse__Milestone__c> milestones = [SELECT Id, Name, pse__Target_Date__c FROM pse__Milestone__c WHERE pse__Project__c =: projectId ORDER BY pse__Target_Date__c];
        
        Integer currentRow=0;
        Date targetDate;
        for(pse__Milestone__c milestone : milestones) {
            PhaseSummary ps = new PhaseSummary();
            ps.milestone=milestone.Name;
            if(currentRow == 0) {
                ps.startDate=project.pse__Start_Date__c;
            } else {
                ps.startDate=targetDate;
            }
            targetDate=milestone.pse__Target_Date__c;
            ps.endDate=milestone.pse__Target_Date__c;
            
            ps.init();
            
            phases.add(ps);
            currentRow ++;
        }
        
        phases[phases.size()-1].endDate = project.pse__End_Date__c;
        if(project.pse__Stage__c!='Completed' && project.pse__Stage__c!='Close-Out') {
            phases[phases.size()-1].endDate = project.pse__End_Date__c.addDays(365);
        }
        
        getBillableData();
        getNonBillableData();
        getProjectTotals();
        
        return phases;
    }
    
    private void getBillableData() {
        AggregateResult [] expenses = [SELECT pse__Milestone__r.Name Milestone, SUM(pse__Amount__c) Amount 
                                       FROM pse__Expense__c 
                                       WHERE pse__Project__c =: projectId 
                                       GROUP BY pse__Milestone__r.Name 
                                       ORDER BY pse__Milestone__r.Name];
        
        Map<String, Decimal> expenseMap = new Map<String, Decimal>();
        for(AggregateResult expense : expenses) {
            expenseMap.put((String)expense.get('Milestone'), (Decimal)expense.get('Amount'));
        }
        
        for(PhaseSummary phase : phases){
            System.debug('-------- phase.startDate: ' + phase.startDate + ' - ' + phase.endDate);
            
            AggregateResult [] sowHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Bill_Rate__c) BillRate, SUM(Baseline_Estimated_Hours__c) BaselineHours
                                           FROM pse__Est_Vs_Actuals__c 
                                           WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: phase.startDate AND pse__End_Date__c <=: phase.endDate
                                           AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=true AND Baseline_Estimated_Hours__c != null
                                           GROUP BY pse__Resource__r.Name];
            
            AggregateResult [] estHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Bill_Rate__c) BillRate, SUM(pse__Estimated_Hours__c) EstimatedHours
                                           FROM pse__Est_Vs_Actuals__c 
                                           WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: phase.startDate AND pse__End_Date__c <=: phase.endDate
                                           AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=true
                                           GROUP BY pse__Resource__r.Name];
            
            AggregateResult [] actHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Bill_Rate__c) BillRate, SUM(pse__Actual_Hours__c) ActualHours
                                           FROM pse__Est_Vs_Actuals__c 
                                           WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: phase.startDate AND pse__End_Date__c <=: phase.endDate
                                           AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=true
                                           GROUP BY pse__Resource__r.Name];
            
            System.debug('-------- sow: ' + sowHours);
            System.debug('-------- est: ' + estHours);
            System.debug('-------- act: ' + actHours);
            
            for(AggregateResult sow : sowHours) {
                phase.sowHours += (Decimal)sow.get('BaselineHours'); 
                phase.sowDollars += (Decimal)sow.get('BaselineHours')*(Decimal)sow.get('BillRate');
            }
            for(AggregateResult est : estHours) {
                phase.estHours += (Decimal)est.get('EstimatedHours');
                phase.estDollars += (Decimal)est.get('EstimatedHours')*(Decimal)est.get('BillRate');
            }
            for(AggregateResult act : actHours) {
                phase.actualHours += (Decimal)act.get('ActualHours');
                phase.actualDollars += (Decimal)act.get('ActualHours')*(Decimal)act.get('BillRate');
            }
            if(System.today()<=phase.endDate) {
                phase.etcHours += (phase.estHours-phase.actualHours);
                phase.etcDollars += (phase.estDollars-phase.actualDollars);
            }
            
            phase.eacHours += (phase.actualHours+phase.etcHours);
            phase.eacDollars += (phase.actualDollars+phase.etcDollars);
            
            phase.varianceHours += (phase.eacHours-phase.sowHours);
            phase.varianceDollars += (phase.eacDollars-phase.sowDollars);
            if(expenseMap.containsKey(phase.milestone)) { phase.expenses = expenseMap.get(phase.milestone); }
            
            totals.sowHours += phase.sowHours;
            totals.sowDollars += phase.sowDollars;
            totals.estHours += phase.estHours;
            totals.estDollars += phase.estDollars;
            totals.actualHours += phase.actualHours;
            totals.actualDollars += phase.actualDollars;
            totals.etcHours += phase.etcHours;
            totals.etcDollars += phase.etcDollars;
            totals.eacHours += phase.eacHours;
            totals.eacDollars += phase.eacDollars;
            totals.varianceHours += phase.varianceHours;
            totals.varianceDollars += phase.varianceDollars;
            totals.expenses += phase.expenses;
        }
        
        System.debug(phases);
    }
    
    private void getNonBillableData() {
        Date endDate = project.pse__End_Date__c.addDays(365);
        AggregateResult [] sowHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Cost_Rate_Amount__c) BillRate, SUM(Baseline_Estimated_Hours__c) BaselineHours
                                       FROM pse__Est_Vs_Actuals__c 
                                       WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: project.pse__Start_Date__c AND pse__End_Date__c <=: endDate
                                       AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=false AND Baseline_Estimated_Hours__c != null
                                       GROUP BY pse__Resource__r.Name];
        
        AggregateResult [] estHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Cost_Rate_Amount__c) BillRate, SUM(pse__Estimated_Hours__c) EstimatedHours
                                       FROM pse__Est_Vs_Actuals__c 
                                       WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: project.pse__Start_Date__c AND pse__End_Date__c <=: endDate
                                       AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=false
                                       GROUP BY pse__Resource__r.Name];
        
        AggregateResult [] actHours = [SELECT pse__Resource__r.Name Resource, MAX(pse__Assignment__r.pse__Cost_Rate_Amount__c) BillRate, SUM(pse__Actual_Hours__c) ActualHours
                                       FROM pse__Est_Vs_Actuals__c 
                                       WHERE pse__Project__c =: projectId AND pse__Start_Date__c >=: project.pse__Start_Date__c AND pse__End_Date__c <=: endDate
                                       AND pse__Time_Period_Type__c='Week' AND pse__Assignment__r.pse__is_Billable__c=false
                                       GROUP BY pse__Resource__r.Name];
        
        System.debug('-------- sow: ' + sowHours);
        System.debug('-------- est: ' + estHours);
        System.debug('-------- act: ' + actHours);
        
        for(AggregateResult sow : sowHours) {
            nonBill.sowHours += (Decimal)sow.get('BaselineHours'); 
            nonBill.sowDollars += (Decimal)sow.get('BaselineHours')*(Decimal)sow.get('BillRate');
        }
        for(AggregateResult est : estHours) {
            nonBill.estHours += (Decimal)est.get('EstimatedHours');
            nonBill.estDollars += (Decimal)est.get('EstimatedHours')*(Decimal)est.get('BillRate');
        }
        for(AggregateResult act : actHours) {
            nonBill.actualHours += (Decimal)act.get('ActualHours');
            nonBill.actualDollars += (Decimal)act.get('ActualHours')*(Decimal)act.get('BillRate');
        }
        
        nonBill.etcHours += (nonBill.estHours-nonBill.actualHours);
        nonBill.etcDollars += (nonBill.estDollars-nonBill.actualDollars);
        
        nonBill.eacHours += (nonBill.actualHours+nonBill.etcHours);
        nonBill.eacDollars += (nonBill.actualDollars+nonBill.etcDollars);
        
        nonBill.varianceHours += (nonBill.eacHours-nonBill.sowHours);
        nonBill.varianceDollars += (nonBill.eacDollars-nonBill.sowDollars);
    }
    
    private void getProjectTotals() {
        projectTotals.sowHours += totals.sowHours+nonBill.sowHours;
        projectTotals.sowDollars += totals.sowDollars+nonBill.sowDollars;
        projectTotals.estHours += totals.estHours+nonBill.estHours;
        projectTotals.estDollars += totals.estDollars+nonBill.estDollars;
        projectTotals.actualHours += totals.actualHours+nonBill.actualHours;
        projectTotals.actualDollars += totals.actualDollars+nonBill.actualDollars;
        projectTotals.etcHours += totals.etcHours+nonBill.etcHours;
        projectTotals.etcDollars += totals.etcDollars+nonBill.etcDollars;
        projectTotals.eacHours += totals.eacHours+nonBill.eacHours;
        projectTotals.eacDollars += totals.eacDollars+nonBill.eacDollars;
        projectTotals.varianceHours += totals.varianceHours+nonBill.varianceHours;
        projectTotals.varianceDollars += totals.varianceDollars+nonBill.varianceDollars;
        projectTotals.expenses += totals.expenses+nonBill.expenses;
    }
}