/***************************************************************************
//
// Description    : Class that returns the state of a given trigger and
//                : if it should execute when test methods are executed
//                  
// Jul 24, 2020   : Randy Wandell   Original  
//   
//***************************************************************************/
@isTest (SeeAllData=false)
public class TriggerState_Test {

    @isTest static void testForTrigger() {
		TriggerState.isRunning=false;
        TriggerState.isActive(Account.getSObjectType(), 'TestClassName');
        TriggerState.thisTriggerIsRunning('TestClassName');
        System.assertEquals(true, TriggerState.isActive);
        System.assertEquals(false, TriggerState.isRunning);
    }
    
    @isTest static void testForObject() {
		TriggerState.isRunning=false;
        TriggerState.isActive(Account.getSObjectType());
        System.assertEquals(true, TriggerState.isActive);
        System.assertEquals(false, TriggerState.isRunning);
    }


}