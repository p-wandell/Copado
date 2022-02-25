/**
 * Created by melindagrad on 3/15/18.
 */



public with sharing class Peak_AnnouncementEmailController {
    /*
     * This method will send emails to Community Users with a certain Profile. The email will be sent to the
     * email address on the Community User's related Contact record, and will use the specified Email Template.
     *
     * To use this method set the emailTemplateName and profileName to the desired Email Template and User Profile
     */
    @InvocableMethod
    public static void sendAnnouncementEmail(List<Id> announcementIDs){

        String emailTemplateName = 'Announcement Email';
        String profileName = 'Customer Community Login User';

        //Query Email Template ID
        ID templateId = [SELECT Id FROM EmailTemplate WHERE EmailTemplate.Name =: emailTemplateName].Id;

        //Query Community Users by Profile Name
        List<User> recipientList = [SELECT Id, Name, Email, ContactId, Contact.Email FROM User WHERE Profile.Name =:profileName];

        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();

        //For each Announcement
        if(Peak_Utils.emailsTurnedOn() == true){
            for(Id theAnnouncementId : announcementIDs) {

                //For each recipient, create a single email message and add to to List
                for (User theUser: recipientList) {

                    if(theUser.ContactId != NULL && theUser.Contact.Email != null) {
                        Messaging.SingleEmailMessage singleMessage = new Messaging.SingleEmailMessage();

                        singleMessage.setTemplateId(templateId);

                        //Send email to Contact in order to correctly populate merge fields on template
                        singleMessage.setTargetObjectId(theUser.ContactId);
                        singleMessage.setWhatId(theAnnouncementId);
                        singleMessage.saveAsActivity = false;

                        //Add to list of messages
                        messageList.add(singleMessage);
                    } else {
                        // Dang, not actually a contact
                    }
                }
            }
        }
        //Send List of emails
        Messaging.SendEmailResult[] results = messaging.sendEmail(messageList);

        //Debug message to verify email was sent
        for(Integer i = 0; i < results.size(); i++) {
            System.debug('Results = ' + results[i].isSuccess());
        }
    }
}