/*
 * Copyright (c) 2021. 7Summits Inc.
 */

@IsTest
public class x7sIdeasNotifyModelTest {

	@IsTest static void testModel() {
		x7sIdeasNotifyModel notifyModel = new x7sIdeasNotifyModel('0123456789012345', 'nameVariable', 'contextVariable', 'detailVariable', 'urlVariable');
		notifyModel.Dump('Testing dump: ');
	}
}