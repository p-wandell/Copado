@isTest
public class ALMStatusMappingHandler_Test {

    @isTest static void testALMStatus() {
        System.assertEquals('To Do', ALMStatusMappingHandler.getALMStatus('Approved'));
        System.assertEquals('To Do', ALMStatusMappingHandler.getALMStatus(null, 'Approved'));
    }
    
    @isTest static void testCopadoStatus() {
        System.assertEquals('Approved', ALMStatusMappingHandler.getCopadoStatus('To Do'));
        System.assertEquals('Approved', ALMStatusMappingHandler.getCopadoStatus(null, 'To Do'));
    }
    
    @isTest static void testALMStatusForStory() {
        System.assertEquals('To Do', ALMStatusMappingHandler.getALMStatus(null, 'Approved'));
    }
    
    @isTest static void testCopadoStatusForStory() {
        System.assertEquals('Approved', ALMStatusMappingHandler.getCopadoStatus(null, 'To Do'));
    }    
}