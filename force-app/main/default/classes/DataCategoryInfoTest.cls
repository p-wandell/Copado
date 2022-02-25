@isTest
public class DataCategoryInfoTest {

    @isTest
    public static void testDataCategoryInfo(){
        DataCategoryInfo dci = new DataCategoryInfo('Name','Label','displayName'); 
        System.assertEquals(dci.getName(), 'Name');
        System.assertEquals(dci.getLabel(), 'Label');
        System.assertEquals(dci.getDisplayName(), 'displayName');
    }
}