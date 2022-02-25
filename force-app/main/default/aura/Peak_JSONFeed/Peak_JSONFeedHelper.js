/**
 * Created by kentheberling on 5/9/18.
 */
({
    assignTestRecords: function(component,response){
        component.set("v.feedItems",JSON.parse(response.responseBody)); // assign JSON parsed string body as the list of actual feed items!
    },
    assignEventsRecords: function(component,response){
        // component.set("v.feedItems",JSON.parse(response.responseBody)); // assign JSON parsed string body as the list of actual feed items!
    },
    assignBlogRecords: function(component,response){
        // Expecting a Response from WP plugin JSON-API, which puts posts in a "posts" node
        var serialiazedResponse = JSON.parse(response.responseBody);
        component.set("v.feedItems",serialiazedResponse.posts); // assign JSON parsed string body as the list of actual feed items!
    }
})