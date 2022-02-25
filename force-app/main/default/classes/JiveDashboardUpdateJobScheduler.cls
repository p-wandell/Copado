/**
 * Created by jasonmiletta on 2/28/17.
 */
global with sharing class JiveDashboardUpdateJobScheduler implements Schedulable{

    global static String CRON_EXPRESSION = '0 0 0 * * ?'; // every day
    public static final Integer MAX_SCHEDULED_APEX_JOBS = 100;

    global void execute(SchedulableContext sc) {
        new JiveDashboardUpdateJob().execute();
    }

    public static void schedule(String cron) {
        if(!MaxScheduledJobsReached()) {
            if (String.isBlank(cron)) {
                cron = CRON_EXPRESSION;
            }

            try {
                System.schedule('Update Jive Dashboard with Sales Data', cron, new JiveDashboardUpdateJobScheduler());
            } catch (Exception ex) {
                if (Test.isRunningTest()) {
                    JiveDashboardUpdateJob job = new JiveDashboardUpdateJob();
                    job.execute();
                } else {
                    System.debug('Failed to schedule job: ' + ex);
                }
            }
        }
    }

    // Determine whether the maximum number of Scheduled APEX Jobs has been reached
    private static Boolean MaxScheduledJobsReached() {
        return (GetScheduledJobs().size() >= MAX_SCHEDULED_APEX_JOBS) ;
    }

    // Returns all Scheduled Apex jobs that have not been started yet
    private static List<CronTrigger> GetScheduledJobs() {

        List<CronTrigger> scheduledJobList = [
                SELECT Id, NextFireTime
                FROM CronTrigger
                WHERE State IN ('WAITING','ACQUIRED','EXECUTING') OR NextFireTime != NULL
        ];
        return scheduledJobList;
    }
}