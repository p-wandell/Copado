/**
 * Created by brianpoulsen on 7/22/18.
 */
({
    isExternalLink: function(component) {
        var link = component.get("v.link");
        if (link.indexOf("http://") === 0 || link.indexOf("https://") === 0) {
            component.set("v.externalLink", true);
        }
    },
    createTopicSlug: function (str) {
        var strLower = str.toLowerCase();
        return strLower.replace(/[^A-Z0-9]+/ig, "-");
    },
});