/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

/**
 * This class will call the batch process to apply the share settings.
 *
 * In order to avoid hitting the SF SOQL Limit, apply the following to determine the optimal batch size.
 * Find the criteria set with the most criteria assignments.
 * Add 2 for process overhead.
 * Set SHARE_BATCH_SIZE to (200 / (max_criteria + 1)) - 1
 *
 * ex: Max criteria = 5.
 * Use 200 / 7 (rounded down to the nearest Integer), subtract 1
 * set SHARE_BATCH_SIZE = 27
 * (I would round down to 20 for a little more head room)
 */
@SuppressWarnings('PMD.ApexSharingViolations, PMD.ApexCRUDViolation')
global class x7sFilesShareBatchSchedule implements Schedulable {
	private final String DEFAULT_SETTING = 'Default';
	private final Integer SHARE_BATCH_SIZE = 20;

	global void execute(SchedulableContext sc) {
		X7S_Files_Global__mdt setting = X7S_Files_Global__mdt.getInstance(DEFAULT_SETTING);
		Integer batchSize = setting != null && setting.Batch_Size__c != null ? Integer.valueOf(setting.Batch_Size__c) : SHARE_BATCH_SIZE;

		x7sFilesShareBatch sharingBatch = new x7sFilesShareBatch();
		Database.executeBatch(sharingBatch, batchSize);
	}
}