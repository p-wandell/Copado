/**
 * Created by kentheberling on 8/25/18.
 */
({

    /*
        Take in a big array, for each item in it, check if the object's Title field is contained in a string, if so, add item to sublist
        This business case = we have an array of ALL fields for a record. We loop through and check against a comma-separated sub-list of fields. We only return a sub-list array of items matching that comma-separated string.
     */
    createSubList: function(arrayToCheck,stringToCheck){
        var subList = [];

        // Ok, need EXACT matches, so put into array, then object, otherwise partial string matches return false positives!
        var stringToCheckList = stringToCheck.split(',');
        var stringToCheckMap = {};
        // Now we can find by a key!
        stringToCheckList.forEach(function (thisString) {
           stringToCheckMap[thisString] = thisString;
        });

        // Ok, loop through full array. For each item, check if we have a key in our sublist stringToCheckList map. If so, add item to sublist
        arrayToCheck.forEach(function(thisItem){
            if (stringToCheckMap[thisItem.title] != null){
                subList.push(thisItem);
            }
        });

        return subList;
    },
    /*
        Add a second string to a first string if that second string is not blank
     */
    addToCommaSepString: function(originalString,additionalString){
        if (additionalString.length > 0){
            originalString += ','+additionalString;
        }
        return originalString;
    }

})