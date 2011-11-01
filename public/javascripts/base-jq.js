jQuery.noConflict();

jQuery(document).ready(function($){
	
	$("#tivit-container").jTabs({
	    nav: "ul#tabs-nav",
	    tab: ".tabContent .tabInfo",
	    //"fade", "fadeIn", "slide", "slide_down" or ""
	    effect: "fade",
	    hashchange: false
	});

	console.log('[Yaniv] in document ready function');

	var inputEl = jQuery('#new-activity input#name');
    inputEl.live('focus',function(){
        openNewActivity();
    });

    var cancelActivBtn = jQuery('.form-cancel-button');
    cancelActivBtn.live('click',function(){
    	closeNewActivity();
    });

     jQuery('#activity-overlay').live('click',function(){
         closeNewActivity();
     });

/* Dashboard - hover over record show highlight blue color */
/*
    $(".record").hover(
	   function() {
	      $(this).addClass('record-hovered');
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	   }
	);
*/

    /*jQuery(document).click(function(){
         console.log('click');
        jQuery('.status-list-dialog').remove();
     });*/



    var statusIcon = jQuery('.status .icon');
    var statusList = '<div class="status-list-dialog">'+
                        '<ul class="status-list">'+
                            '<li class="unread"><div class="ico"></div>Not started</li>'+
                            '<li class="inprog"><div class="ico"></div>Im on it</li>'+
                            '<li class="complete"><div class="ico"></div>Im finished</li>'+
                            '<li class="busy"><div class="ico"></div>Im too busy</li>'+
                            '<li class="attention"><div class="ico"></div>Propose new time</li>'+
                        '</ul>'+
                     '</div>';
     statusIcon.live('click',function(){
    	var recState = jQuery(this).closest('li');
    		console.log(recState.attr('class'));
	    	if(recState.hasClass('unread'))
	    	{
	    		jQuery(this).parent().append(statusList);
	    		jQuery('.status-list-dialog').find('.unread').remove();
	    		jQuery('.status-list-dialog').show();
	    	}
	    	else if(recState.hasClass('inprog'))
	    	{
	    		jQuery(this).parent().append(statusList);
	    		jQuery('.status-list-dialog').find('.inprog').remove();
	    		jQuery('.status-list-dialog').show();
	    	}
	    	else if(recState.hasClass('complete'))
	    	{
	    		jQuery(this).parent().append(statusList);
	    		jQuery('.status-list-dialog').find('.complete').remove();
	    		jQuery('.status-list-dialog').show();
	    	}
	    	else if(recState.hasClass('busy'))
	    	{
	    		jQuery(this).parent().append(statusList);
	    		jQuery('.status-list-dialog').find('.busy').remove();
	    		jQuery('.status-list-dialog').show();
	    	}
	    	else if(recState.hasClass('attention'))
	    	{
	    		jQuery(this).parent().append(statusList);
	    		jQuery('.status-list-dialog').find('.attention').remove();
	    		jQuery('.status-list-dialog').show();
	    	}


     });


     $('body').click(function(event) {

         if (!jQuery(event.target).closest('.status-list-dialog').length && jQuery('.status-list-dialog').is(':visible')) {
             jQuery('.status-list-dialog').remove();
         }else if(!jQuery(event.target).closest('#user-nav').length && jQuery('#sm_1').is(':visible')){
        	 jQuery('#sm_1').hide();
         }
     });

     var statusCh = jQuery('.status-list-dialog .status-list li');
     statusCh.live('click',function(){



    	 record = jQuery(this).parents('.record');
    	 newState = jQuery(this).attr('class');
    	 newClassValue = 'record ' + newState;
    	 //console.log(newState=='complete');
    	 if(newState=='inprog' || newState=='complete'){
    		 switch(newState){
	    		 case 'inprog':
	    			 var confirmDialogTitle = 'Right on!';
	    			 var confirmDialogText = 'Want to add a comment or attach file?';
	    			 break;
	    		 case 'complete':
	    			 var confirmDialogTitle = 'You rock!';
	    			 var confirmDialogText = 'Want to add a comment or attach file?';
	    			 break;
    		 }

    		 var confirmDialog = '<div class="confirmDialog">'+
				'<div class="wrapper">'+
					'<h2>'+ confirmDialogTitle +'</h2>'+
					'<div class="txt">'+ confirmDialogText +'</div>'+
					'<div class="buttons">'+
						'<span class="cancel-button">Cancel</span>'+
            			'<span class="submit-button">OK, go to this activity</span>'+
					'</div>'+
				'</div>'+
			 '</div>';
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 jQuery('#activity-overlay').show();
    		 jQuery(this).parents('.status').append(confirmDialog);
    		 jQuery('.status-list-dialog').remove();
    		 record.attr('class',newClassValue);

    	 }
    	 else
    	 {
    		 jQuery('.status-list-dialog').remove();
    		 record.attr('class',newClassValue);
    	 }

     });
     jQuery('.confirmDialog .cancel-button').live('click', function(){
         jQuery('.confirmDialog').remove();
         jQuery('#activity-overlay').fadeOut();
         jQuery('#new-activity-background').removeClass('tempHide');
     });
     jQuery('.confirmDialog .submit-button').live('click', function(){
         jQuery('.confirmDialog').remove();
         jQuery('#new-activity-background').removeClass('tempHide');
         jQuery('#new-activity-background .input-name').focus();
     });

 });


function openNewActivity(){
    var layer = jQuery('#new-activity-complete');

    if (!jQuery(layer).is(":visible"))
    {
        jQuery('#activity-overlay').show();
        jQuery(layer).slideDown('slow');

    }

}
function closeNewActivity(){
    var layer = jQuery('#new-activity-complete');
    if(jQuery('#calBorder').is(':visible')){
        closewin("due"); stopSpin();
    }
    jQuery(layer).slideUp('slow',function(){
		jQuery('#activity-overlay').fadeOut();
    });
    jQuery(':input','#new-activity-form')
    .not(':button, :submit, :reset, :hidden')
    .val('')
    .removeAttr('checked')
    .removeAttr('selected');
    jQuery('#new-activity-form textarea').val('');

}
/* This is not in use */
function changeBackground(color){
	
	jQuery('#page-container').css('background', color);	
	jQuery('body').css('background', color);	
	
}
