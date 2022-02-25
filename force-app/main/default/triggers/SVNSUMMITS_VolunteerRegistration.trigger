/**
 * Do not allow a user to sign up for the same task/need twice
 */

trigger SVNSUMMITS_VolunteerRegistration on Volunteer_Registration__c (before insert, before update) {


    // Easy work for single... more work for bulkifying!

    // Build a map of new record with a key of the user.id + task.id for unique keys that should never be duplicated!
    Map<String, Volunteer_Registration__c> registrationMap = new Map<String, Volunteer_Registration__c>();
    List<Id> userIds = new List<Id>();
    List<Id> taskIds = new List<Id>();
    for (Volunteer_Registration__c registration : System.Trigger.new) {
        // Put user+task into map
        registrationMap.put((String)registration.User__c + (String)registration.Volunteer_Need__c,registration);

        // List of tasks to query by user
        userIds.add(registration.User__c);
        taskIds.add(registration.Volunteer_Need__c);
    }

    // Query all registrations matching users and tasks/needs from the new records
    List<Volunteer_Registration__c> existingRegistrations = [Select User__c,Volunteer_Need__c from Volunteer_Registration__c where User__c in :userIds and Volunteer_Need__c in :taskIds];

    // For all existing, check for a user+task match. If one exists, we are trying to insert a duplicate!
    String newKey;
    for (Volunteer_Registration__c existingRegistration: existingRegistrations){
        // Note the key
        newKey = (String)existingRegistration.User__c+ (String)existingRegistration.Volunteer_Need__c;

        // We have a match - note the error
        if (registrationMap.containsKey(newKey)){
            registrationMap.get(newKey).User__c.addError('This user is already signed up for this Volunteer Need');
        }
    }


}