/**
 * Created by brianpoulsen on 11/8/17.
 * Updated by jonbalza on 11/23/18.
 */
({
    accordionOpeningClass: 'is-opening',
    accordionClosingClass: 'is-closing',
    accordionVisibleClass: 'is-visible',
    accordionSlideDownTimeout: null,
    accordionSlideUpTimeout: null,
    accordionSlideUpClassTimeout: null,

    // Shows an element
    slideDown: function (component, event, helper, accordion, callback) {
        var accordionElement = accordion.getElement();
        var transitionDuration = component.get("v.transitionDuration");

        // Get the natural height of the element
        if(accordionElement && !$A.util.hasClass(accordion, helper.accordionVisibleClass)) {
            clearTimeout(helper.accordionSlideUpTimeout);
            clearTimeout(helper.accordionSlideUpClassTimeout);

            accordionElement.style.transitionDuration = transitionDuration + 'ms';
            var getHeight = function () {
                accordionElement.style.display = 'block'; // Make it visible
                var height = accordionElement.scrollHeight + 'px'; // Get it's height
                accordionElement.style.display = ''; //  Hide it again
                return height;
            };

            var height = getHeight(); // Get the natural height
            $A.util.addClass(accordion, helper.accordionOpeningClass); // Make the element visible
            accordionElement.style.height = height; // Update the height

            // Once the transition is complete, remove the inline height so the content can scale responsively
            helper.accordionSlideDownTimeout = setTimeout($A.getCallback(function () {
                accordionElement.style.height = '';
                $A.util.removeClass(accordion, helper.accordionOpeningClass);
                $A.util.addClass(accordion, helper.accordionVisibleClass); // Make the element visible
                if(callback) {
                    callback();
                }
            }), transitionDuration);
        }
    },

    // Hide an element
    slideUp: function(component, event, helper, accordion, callback) {
        var accordionElement = accordion.getElement();
        var transitionDuration = component.get("v.transitionDuration");

        if(accordionElement && $A.util.hasClass(accordion, helper.accordionVisibleClass)) {
            clearTimeout(helper.accordionSlideDownTimeout);

            accordionElement.style.transitionDuration = transitionDuration + 'ms';
            // Give the element a height to change from
            accordionElement.style.height = accordionElement.scrollHeight + 'px';

            // Set the height back to 0
            helper.accordionSlideUpTimeout = setTimeout($A.getCallback(function () {
                $A.util.addClass(accordion, helper.accordionClosingClass);
                setTimeout($A.getCallback(function () {
                    $A.util.removeClass(accordion, helper.accordionVisibleClass);
                    accordionElement.style.height = '0';
                }), 1);
            }), 10);

            // When the transition is complete, hide it
            helper.accordionSlideUpClassTimeout = setTimeout($A.getCallback(function () {
                $A.util.removeClass(accordion, helper.accordionClosingClass);
                accordionElement.style.height = '';
                if(callback) {
                    callback();
                }
            }), transitionDuration);
        }
    }
})