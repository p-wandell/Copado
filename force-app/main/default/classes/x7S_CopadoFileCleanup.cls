global class x7S_CopadoFileCleanup implements Schedulable {
    global void execute(SchedulableContext context) {
		List<ContentDocument> files = [SELECT Id FROM ContentDocument WHERE Title LIKE '%Deploy-aB6%' AND CreatedDate<LAST_N_DAYS:30];
        delete files;
    }
}