public class JiraInterationExtension {
    
    public static Id projectId { get; set; }
    public static copado__Project__c project { get; set; }
    private static String jobPrefix = 'Copado project synch - ';
    
    public static void cancelCurrentJob() {
        setProject();
        System.debug('------ Cancelling current jobs -----');
        Set<Id> cronJobIds = new Set<Id>();
        List<CronJobDetail> cronJobs = [SELECT Id, Name FROM CronJobDetail WHERE Name =: jobPrefix + project.copadoccmint__Project_External_Id__c];
        System.debug('-------- cronjobs: ' + cronJobs);
        for(CronJobDetail cronJob : cronJobs) {
            cronJobIds.add(cronJob.Id);
        }
        
        if(!cronJobIds.isEmpty()) {
            List<CronTrigger> abort_job = [SELECT Id FROM CronTrigger WHERE CronJobDetailId IN : cronJobIds];
            
            for (CronTrigger t : abort_job) { 
                System.abortJob(t.Id); 
            }
        }
    }
    
    public static void scheduleJob() {
        cancelCurrentJob();
        Boolean withSprint = true; 
        String scheduledHours=''+project.Schedule_Start__c;
        if(project.Schedule_End__c>project.Schedule_Start__c) { scheduledHours += '-'+project.Schedule_End__c; }
        
        copadoccmint.ScheduleUserStoryFetch scheduledClass = new copadoccmint.ScheduleUserStoryFetch (projectId, withSprint);
        String scheduleJobId = system.schedule(jobPrefix + project.copadoccmint__Project_External_Id__c, '0 0 ' + scheduledHours + ' ? * MON-FRI', scheduledClass);
        System.debug('------- scheduleJobId: ' + scheduleJobId);
    }
    
    private static void setProject() {
        projectId = ApexPages.currentPage().getParameters().get('pid');
        project = [SELECT Id, copadoccmint__Project_External_Id__c, Name, Schedule_Start__c, Schedule_End__c FROM copado__Project__c WHERE Id =: projectId];
        System.debug('-------- project: ' + project);
    }
    
}