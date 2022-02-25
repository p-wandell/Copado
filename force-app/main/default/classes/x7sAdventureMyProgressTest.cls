/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sAdventureMyProgressTest {


    @IsTest
    public static void testAdventureMyProgressTest() {

        x7sAdventureMyProgress myAdventureProgress = new x7sAdventureMyProgress();

        myAdventureProgress.totalTasksAssigned = 10;
        myAdventureProgress.totalCompletedTasks = 5;
        myAdventureProgress.adventureProgress = (Decimal.valueOf(myAdventureProgress.totalCompletedTasks) / Decimal.valueOf(myAdventureProgress.totalTasksAssigned)) * 100;

        System.assertEquals(myAdventureProgress.totalTasksAssigned, 10);
        System.assertEquals(myAdventureProgress.totalCompletedTasks, 5);
        System.assertEquals(myAdventureProgress.adventureProgress, 50);
    }

}