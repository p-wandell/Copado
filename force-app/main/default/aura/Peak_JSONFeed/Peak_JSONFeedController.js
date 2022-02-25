/**
 * Created by kentheberling on 5/7/18.
 */
({
    initJSONFeed: function(component,event,helper){
        var endpointURL = component.get("v.feedUrlEndpoint");
        var queryLimit = component.get("v.recordsToShow");
        var feedType = component.get("v.feedType");

        var params = {
            "endpointUrl": endpointURL,
            "recordsToShow": queryLimit,
            "feedType": feedType
        };
        
        helper.doCallout(component,"c.getJSONFeed",params).then(function(response){
            if(response.responseCode == 200 && response.errorMessage == null){
                component.set("v.feed",response); // assign response (which has status code, etc.)

                // Which type of feed are we dealing with?
                // Write an appropriate handler for each in helper (because different feeds will have the actual list of items in a different spot, or named differently)
                // It's MUCH easier to do this in JS than it is to write an Apex wrapper for each possible feed
                switch(feedType) {
                    case 'Blog':
                        helper.assignBlogRecords(component,response);
                        break;
                    case 'Events':
                        helper.assignEventsRecords(component,response);
                        break;
                    default:
                        helper.assignTestRecords(component,response);
                }
                component.set("v.isJSONFeedInit",true);
            } else {
                helper.showMessage('Error','Status Code: ' + response.responseCode + ' ' + response.errorMessage);
            }
        }).catch(function(error){
            console.log("Failed with state: " + error);
            helper.showMessage('Error',error);
        });

    }
})