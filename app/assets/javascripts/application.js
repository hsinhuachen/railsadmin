// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require bootstrap/carousel
//= require jquery.waypoints.min

$(function(){
	svgimg();

    $(".slider").bxSlider({
        mode: "fade",
        controls: false,
        pager: false,
        auto: true,
        speed: 800,
        autoDelay: 4000
    });

    $(".gotop").on('click', function(event) {
        $("body,html").animate({
          scrollTop: 0,
        }, 1200);

        event.preventDefault();
    })
})

function productShow(){
    $(".img-item").each(function(index, el) {
        $(".img-item:eq(" + index + ")").waypoint(function(direction) {
            $(".img-item:eq(" + index + ")").addClass('in');
        }, {
            offset: '70%'
        });
    });
}

$(window).on("load", function (e) {
    var progress = 0;
    var imgCount = $('img').length;
    var baseCount = 0;

    if(imgCount > 0){
        $('img').each(function(){
            var src = $(this).attr('src');
            $('<img>').attr('src',src).on('load',function(){
                progress++;

                if(progress == imgCount) {
                    $("#loading").addClass('fadeOut');

                    setTimeout(function(){
                        $("#loading").remove();
                    },600);
                    
                    setTimeout(function(){
                        if($(".img-item").length > 0){
                            productShow();
                        }
                    }, 600);
                }
            });
        });
    }else{
        $("#loading").addClass('fadeOut');

        setTimeout(function(){
            $("#loading").remove();
        },600);
    }
});
$(window).scroll(function(event) {
	var scrolltop = $(window).scrollTop();

	if(scrolltop > $(window).height() - ($('#mainNav').outerHeight(true)/2)){
		$("#header").addClass('black');
	}else{
		$("#header").removeClass('black');
	}
});

function svgimg(){
    $('img.svgimg').each(function(){
        var $img = $(this);
        var imgID = $img.attr('id');
        var imgClass = $img.attr('class');
        var imgURL = $img.attr('src');
    
        jQuery.get(imgURL, function(data) {
            // Get the SVG tag, ignore the rest
            var $svg = jQuery(data).find('svg');
    
            // Add replaced image's ID to the new SVG
            if(typeof imgID !== 'undefined') {
                $svg = $svg.attr('id', imgID);
            }
            // Add replaced image's classes to the new SVG
            if(typeof imgClass !== 'undefined') {
                $svg = $svg.attr('class', imgClass+' replaced-svg');
            }
    
            // Remove any invalid XML tags as per http://validator.w3.org
            $svg = $svg.removeAttr('xmlns:a');
            
            // Check if the viewport is set, else we gonna set it if we can.
            if(!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {
                $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))
            }
    
            // Replace image with new SVG
            $img.replaceWith($svg);
    
        }, 'xml');
    
    }); 
}