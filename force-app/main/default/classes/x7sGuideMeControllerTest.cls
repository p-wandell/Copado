@IsTest
public class x7sGuideMeControllerTest {
	private static final String testField = 'ReceivesAdminInfoEmails';

	@IsTest
	public static void testGetRecord()
	{
		String userJson = x7sGuideMeController.getRecord(testField);
		System.AssertNotEquals(null, userJson);
	}

	@IsTest
	public static void testGetRecordException()
	{
		String userJson = x7sGuideMeController.getRecord('noname');
		System.AssertEquals(null, userJson);
	}

	@IsTest
	public static void testUpdateRecord()
	{
		String userJson = x7sGuideMeController.getRecord(testField);
		User testUser = (User)JSON.deserializeStrict(userJson, user.class);

		testUser.put(testField, true);
		x7sGuideMeController.updateUser(JSON.serialize(testUser));

		userJson = x7sGuideMeController.getRecord(testField);
		testUser = (User)JSON.deserializeStrict(userJson, user.class);
		System.Assert(true, testUser.get(testField));
	}

	@IsTest
	public static void testUpdateRecordException()
	{
		String invalidJson = 'abcdef';
		x7sGuideMeController.updateUser(invalidJson);
		System.AssertNotEquals(null, invalidJson);
	}
}