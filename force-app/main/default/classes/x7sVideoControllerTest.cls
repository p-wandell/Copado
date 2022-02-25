/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

@IsTest
private class x7sVideoControllerTest {
    @IsTest
    static void testBehavior() {
        //lets check if the field exist on account or not
        Schema.DescribeSObjectResult objDescribe = Account.SObjectType.getDescribe();
        Boolean doesGalleryFieldExist = objDescribe.fields.getMap().keySet().contains(x7sVideoController.AccountFieldName);

        Account newAccount = new Account();
        newAccount.Name = 'test Account';

        insert newAccount;

        x7sVideoResponse response = x7sVideoController.getInitialData(newAccount.Id);
        if (doesGalleryFieldExist) {
            System.assert(response.success == true);
            System.debug(response.results.size());
            System.assert(response.results.size() == 0);
        } else {
            System.assert(response.success == false);
            System.assert(response.messages[0] == x7sVideoController.ERROR_MISSING_FIELDS);
        }

        //now update the gallery list field
        if (doesGalleryFieldExist) {
            newAccount.put(x7sVideoController.AccountFieldName, '111122221,32323232321');
        }

        update newAccount;

        response = x7sVideoController.getInitialData(newAccount.Id);
        if (doesGalleryFieldExist) {
            System.assert(response.success = true);
            System.assert(response.results.size() == 2);
        } else {
            System.assert(response.success == false);
            System.assert(response.messages[0] == x7sVideoController.ERROR_MISSING_FIELDS);
        }

        //lets try on some odd object where possibility of having this field is very less
        Topic newTopic = new Topic();
        newTopic.Name = 'xyz';
        insert newTopic;

        doesGalleryFieldExist = Topic.SObjectType.getDescribe().fields.getMap().keySet().contains(x7sVideoController.AccountFieldName);
        response = x7sVideoController.getInitialData(newTopic.Id);
        if (doesGalleryFieldExist) {
            System.assert(response.success == true);
            System.debug(response.results.size());
            System.assert(response.results.size() == 0);
        } else {
            System.assert(response.success == false);
            System.assert(response.messages[0] == x7sVideoController.ERROR_MISSING_FIELDS);
        }
    }
}