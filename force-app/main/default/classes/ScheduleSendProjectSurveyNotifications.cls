global class ScheduleSendProjectSurveyNotifications  implements Schedulable {
    private String projectType;
    
    global ScheduleSendProjectSurveyNotifications() {
    	this.projectType='New Project';
    }
    
    global ScheduleSendProjectSurveyNotifications(String projectType) {
    	this.projectType=projectType;
    }
    
    global void execute(SchedulableContext ctx) {
        SendProjectSurveyNotificationsBatch p = new SendProjectSurveyNotificationsBatch(projectType);
        database.executeBatch(p);
    }   
}