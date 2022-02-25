/**
 * Created by brianpoulsen on 3/16/17.
 */
({
	doInit : function(component, event, helper) {

	    var userIdsString = component.get('v.userIdsInput');
        var userIdsArray = userIdsString.split(',');
        var showDots = component.get('v.showDots');

        component.set('v.userIds',userIdsArray);

        setTimeout(function() {
            $(component.find("slider").getElement()).slick({
                    dots: showDots,
                    infinite: false,
                    speed: 300,
                    slidesToShow: 2,
                    slidesToScroll: 2,
                    responsive: [
                    {
                        breakpoint : 640,
                        settings : {
                            slidesToShow : 1,
                            slidesToScroll: 1,
                            infinite : true,
                            dots : false,
                            arrows: false
                        }
                    }
                ]
            });
        });
        // prevent default "pull-to-refresh" behavior when running in S1
        $(component.find("slider").getElement()).on("touchmove", function() {
            return false;
        });

    }
})