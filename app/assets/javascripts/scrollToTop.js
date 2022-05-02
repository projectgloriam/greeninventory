(function( $ ) {
    $.fn.scrollToTop = function( options ) {

        //default options.
        var settings = $.extend({
            // These are the defaults.
            position: "bottom-right", //top, top-left, top-right, bottom, bottom-left or bottom-right of the screen
            upwards: 0, //distance from the current postion upwards
            downwards: 0, //distance from the current postion downwards
            toTheLeft: 0, //distance from the current postion to the left
            toTheRight: 0, //distance from the current postion to the right
            elementTop: "", //the element with which you want the "back to the top" to appear when the scrollbar reaches it
            scrollTop: 100, //how many number of pixels from the top when the scroll bar moves do you want the button to appear
            scrollSpeed: 100, //speed of the scrolling up animation
            beforeScroll: function() {}, //custom function before scrolling up
            afterScroll: function() {} //custom function after scrolling up
        }, options );


        //validate values of position. this is prevent invalid positions
    	$.each( ["top", "top-left", "top-right", "bottom", "bottom-left", "bottom-right"], function( key, value ) {
    	  var match = false;

    	  //check if the position is among the list of positions available. If so make match true
		  if(settings.position == value){
		  	match = true;
		  }

		  //if there's no match, make position default
		  if(match == false){
		  	console.log("Element position is not valid. Setting it back to default: bottom-right");
		  	settings.position = "bottom-right";
		  }
		});

        //when an element is defined in the element top, take its scrollTop as the value
        if (settings.elementTop != ""){
        	settings.scrollTop = $(settings.elementTop).offset().top;
        }

        var cssObject = {"position":"fixed", "z-index":4}

        //split position by '-'
        var positionCoordinates = settings.position.split("-");

        //if the position array is one item, add left for the element to stay on the middle
        if (positionCoordinates.length == 1){
        	cssObject["left"] = ($("body").width()-this.width())/2;
        }

        //give the value of 0 to each of the position in the array and add it to the cssObject
        $.each( positionCoordinates, function( key, value ) {
		  cssObject[value]=0;
		});

        //clothe element in a div called _wrapper
        this.wrap( "<div id='scroll_to_top_wrapper'></div>" );

        //set wrapper size to element's width and height
        $("#scroll_to_top_wrapper").width(this.width());
        $("#scroll_to_top_wrapper").height(this.height());

        //make element and its wrapper fixed and positioned by default to the bottom left if no position is specified
        //work on position on the bottom
        $("#scroll_to_top_wrapper").css(cssObject);


        //make link or element positioned relative to the wrapper
        this.css({"position":"relative", "top": -settings.upwards, "bottom": -settings.downwards, "left": -settings.toTheLeft, "right": -settings.toTheRight});

        // hide #element first
		$("#scroll_to_top_wrapper").hide();

		//if an element is specified, its scroll top value is taken and used when the scroll bar passes it

		$(window).scroll(function () {
			if ($(this).scrollTop() > settings.scrollTop) {
				$("#scroll_to_top_wrapper").fadeIn();
			} else {
				$("#scroll_to_top_wrapper").fadeOut();
			}
		});

		// scroll body to 0px on click
		this.click(function () {
			//function before scrolling back to the top
			settings.beforeScroll.call();

			$('body,html').animate({
				scrollTop: 0
			}, settings.scrollSpeed);

		//function after scrolling back to the top
		settings.afterScroll.call();

			return false;
		});

    };
 
}( jQuery ));