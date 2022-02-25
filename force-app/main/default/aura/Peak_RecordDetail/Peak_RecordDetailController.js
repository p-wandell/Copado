/**
 * Created by kentheberling on 8/23/18.
 */
({
    initRecordDetail: function (component,event,helper) {
        // Fields strings
        var fullFieldString = '';
        var fieldsString = component.get('v.fieldsString');
        var fieldsString2 = component.get('v.fieldsString2');
        var fieldsString3 = component.get('v.fieldsString3');
        var fieldsString4 = component.get('v.fieldsString4');
        var fieldsString5 = component.get('v.fieldsString5');

        // Build full string of fields from all section parts
        fullFieldString = fieldsString;
        fullFieldString = helper.addToCommaSepString(fullFieldString,fieldsString2);
        fullFieldString = helper.addToCommaSepString(fullFieldString,fieldsString3);
        fullFieldString = helper.addToCommaSepString(fullFieldString,fieldsString4);
        fullFieldString = helper.addToCommaSepString(fullFieldString,fieldsString5);

        // Set params
        var params = {
            recordIdString: component.get('v.recordId'),
            objectType: component.get('v.objectType'),
            fieldsString: fullFieldString
        };

        // Make call and set it!
        helper.doCallout(component,"c.getRecordDetail",params).then(function(response){
            if(response.success){
                // Set overall response (great for easy error handling, etc)
                component.set('v.peakResponse',response);

                // Create sub-lists of full response for each section!
                component.set('v.returnedFieldList',helper.createSubList(response.peakResults,fieldsString));
                component.set('v.returnedFieldList2',helper.createSubList(response.peakResults,fieldsString2));
                component.set('v.returnedFieldList3',helper.createSubList(response.peakResults,fieldsString3));
                component.set('v.returnedFieldList4',helper.createSubList(response.peakResults,fieldsString4));
                component.set('v.returnedFieldList5',helper.createSubList(response.peakResults,fieldsString5));

            } else {
                helper.showMessage('Error',response.messages[0]);
            }
        }).catch(function(error){
            console.log("Failed with state: " + error);
            helper.showMessage('Error',error);
        }).finally(function(){
            component.set('v.isDetailInit',true);
        });
    }
})