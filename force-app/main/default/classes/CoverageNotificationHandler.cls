public class CoverageNotificationHandler {
    @InvocableMethod(label='Coverage Notifications' description='Send notifications to coverage')
    public static void sendNotification(List<String> notification) {
        for(String n : notification) {
            integer pos=n.indexOf(' - ');
            String projectId=n.left(pos);
            String templateName=n.substring(pos+3);
            
            System.debug(templateName);
            emailSend(projectId, templateName);
        }
    }
    
    private static void emailSend(String projectId, String templateName) {

        List<pse__Assignment__c> contacts = [SELECT Id, pse__Resource__c, pse__Resource__r.Name, pse__Resource__r.Email, pse__Project__r.Name, CreatedDate 

                                             FROM pse__Assignment__c 
                                             WHERE pse__Project__c =: projectId AND pse__Role__c='Coverage'];
        
        EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where DeveloperName =: templateName];
        

        DateTime dt = System.now();
        DateTime checkTime = dt.addMinutes(-1);
        

        if(!contacts.isEmpty()) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            

            for(pse__Assignment__c contact : contacts) {
                System.debug('checkTime: ' + checkTime + '     CreatedDate: ' + contact.CreatedDate);
                if(contact.CreatedDate > checkTime) {

                message.setTargetObjectId(contact.pse__Resource__c); 
                message.setSenderDisplayName('PSA'); 
                message.setReplyTo('no-reply@7summitsinc.com');
                message.setUseSignature(false); 
                message.setBccSender(false); 
                message.setSaveAsActivity(false); 
                
                message.setTemplateID(emailTemplate.Id); 

                    message.setWhatId(contact.Id); 
                    message.toAddresses = new String[] { contact.pse__Resource__r.Email};
                    messages.add(message);
                }
            }
            
            if(!messages.isEmpty()) {

            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
    }
}
}