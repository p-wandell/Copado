/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sExpJoinCommunityControllerTest {

    @IsTest
    public static void testGetUsersWithPublicPhotos() {
        List<User> allUsers = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE UserPreferencesShowProfilePicToGuestUsers = TRUE LIMIT 5];

        // Mark all users as not allowing guest access to their photo
        for (User thisUser : allUsers) {
            thisUser.UserPreferencesShowProfilePicToGuestUsers = false;
        }
        update allUsers;

        // Get User list. This will initially find 0 because there are now no users with public photos. However, the function builds up a list of empty users for us!
        List<User> userList = x7sExpJoinCommunityController.getUsersWithPublicPhotos('2');

        System.assertEquals(2, userList.size());
        
        List<User> userList1 = x7sExpJoinCommunityController.getUsersWithPublicPhotos('0');

    }

}