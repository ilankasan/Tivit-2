jQuery.noConflict();

 jQuery(document).ready(function($){

	$("#tivit-container").jTabs({
	    nav: "ul#tabs-nav",
	    tab: ".tabContent .tabInfo",
	    //"fade", "fadeIn", "slide", "slide_down" or ""
	    effect: "fade",
	    hashchange: false
	});

	var inputEl = jQuery('#new-activity input#name');
    inputEl.live('focus',function(){
        openNewActivity();
    });

    var cancelActivBtn = jQuery('.form-cancel-button');
    cancelActivBtn.live('click',function(){
    	openNewActivity();
    });


 });


function openNewActivity(){
    var layer = jQuery('#new-activity-complete');

    if (!jQuery(layer).is(":visible"))
    {
        jQuery('#activity-overlay').show();
        jQuery(layer).slideDown('slow');

    }
    else
    {
    	jQuery('#activity-overlay').hide();
        jQuery(layer).slideUp('slow');
        jQuery(':input','#new-activity-form')
        .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
        jQuery('#new-activity-form textarea').val('');

    }
}
