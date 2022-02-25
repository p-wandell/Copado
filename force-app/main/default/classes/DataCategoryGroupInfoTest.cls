@isTest
public class DataCategoryGroupInfoTest {
	@isTest
    public static void testDataCategoryGroupInfo(){
        List<DataCategoryInfo> dciList = new List<DataCategoryInfo>();
        DataCategoryGroupInfo dcgi = new DataCategoryGroupInfo('name','label','description',dciList);
        system.assert(dcgi.getDescription() != null);
        system.assert(dcgi.getGroupStructure() != null);
        system.assert(dcgi.getLabel() != null);
        system.assert(dcgi.getName() != null);
    }
}