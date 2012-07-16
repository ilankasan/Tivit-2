jQuery.noConflict();

/* Yaniv's Ajax stuff */
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery(document).ready(function($){

	console.log ('[Yaniv] in Artem DOM ready function');
	
	$("#new-activity-form").validate({
   		//debug: true,
   		submitHandler: function(form) {
	     	form.submit();
     	}     
	});
	
	$.validator.addMethod(
	    "tivitiDate",
	    function(value, element) {
	        // put your own logic here, this is just a (crappy) example
	        return value.match( /^\d{2}([./-])\d{2}\1\d{4}$/);
	    },
	    "Please enter date in format dd-mm-yyyy"
	);
	
	/**************************************************************************/
	/* Yaniv - Create new tivit with Ajax */	
	//jQuery("#create-new-tivit-form").submit(function() {
	//	console.log ('[Yaniv] #create-new-tivit-form clicked');
	//	showLoadingAnimation('.loading-popup');
	//	console.log ('[Yaniv] after loading animation...');
	//	$.post($(this).attr("action"), $(this).serialize(), function() { hideLoadingAnimation ('.loading-popup');}, "script");
	//	return false;
	//});
	/**************************************************************************/
	
	//$('.post-button').live('click', function(){
	jQuery('.new_tivitcomment').live ('submit', function() {
		
		showInlineLoadingAnimation();
		console.log ('[Yaniv] Post comment button clicked');
		
		var record = jQuery(this).parents('.record');				
		addNewComment (record);
						
		//var actionparam = $(this).attr("action") + "";
		//console.log('[Yaniv] action=', actionparam); 

		//var mystring = "hello/world/test/world";
		//var find = "/";
		//var regex = new RegExp(find, "g");
		//var newcommentId = actionparam.replace(regex, "");
		
		//console.log('[Yaniv] newcommentId=', newcommentId); 
		
		//var newCommentId = "new_comment_to_add";
		
		//var ullist = $(this).parents('.list .list');
		//var lastPost = ullist.find ('.post');
		//var newComment = '<li class="record" id="new_comment_to_add"></li>';
		
		// This is critical for making sure the Ajax call will insert the div in the right place. See create.js.erb in tivitcomments viewer folder (JS view)
		//var newComment = '<li class="record" id="' + newcommentId + '"></li>';
		
		//console.log ('[Yaniv] newComment=', newComment);
		
		//lastPost.before(newComment);
		 
		console.log ('[Yaniv] new comments record should be added by now and can accept the new comment partial to be rendered');
		
		$.post($(this).attr("action"), $(this).serialize(), hideInlineLoadingAnimation, "script");
		
		// Empty the input comment box from previous comment text
		$(this)[0].reset();
		
		console.log ('[Yaniv] Ajax call came back...');
		
		return false;

	});
	/**************************************************************************/
	
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
    	closeNewActivity();
    });

     jQuery('#activity-overlay').live('click',function(){
         closeNewActivity();
     });
          
    //$(".record").hover(
	//add from Irina Sorokina
	//an exception for .record on Activity Page
	//$(".record").hover(
    $(".record").not('.tivits .record').not('.main-tivit').hover(
	   function() {
	      //$(this).css('cursor','pointer');
	      $(this).addClass('record-hovered');
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	      //$(this).css('cursor','pointer');
	   }
	);    
	
	/* Yaniv - Dashboard click on tivit takes to adp */
	//var xdf = $(".record").not('.tivits .record').not('.main-tivit');
	/*
	$(".record").not('.tivits .record').not('.main-tivit').click (function(){
		console.log('[Yaniv] clicked on tivit on dashboard');
		var linktoactivitypage = 'form method="POST" action="/activities/83" style="display: none;">' +
			'<input type="hidden" name="_method" value="get">' +
			'<input type="hidden" name="authenticity_token" value="isK4QXkRIhFKt0ZYToHkY9aJttTF8lbs7d7koyyGKB0=">'+
		'</form>'
		
		window.location.href = "/activities/83";

		//$.get("/activities/83");
		console.log ('[Yaniv] Ajax call came back...');
		return false;
		
	});    
	*/
	
	//add from Irina Sorokina
	/*
	$('.conteiner').hover(
	   function() {
	      $(this).addClass('record-hovered');
	      $(this).children('.edit-menu').children('.icon').toggle();
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	      $(this).children('.edit-menu').children('.icon').toggle();
	      $(this).children('.menu-dialog').toggle();
	   }
	);
	*/
	//add from Irina Sorokina
	$('.conteiner').not('.no-hover').hover(
	   function() {
	      $(this).addClass('record-hovered');
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	   }
	);
	
	$('.show-other-tasks').click(function(){
		var that = $(this);
		var thatText = that.text();
		var additionalLIst = that.parent().find('.additional-tivits');
		var thatDataTitle = that.data('title');

		if(!thatDataTitle){
			that.data('title',thatText);
			that.text('Show less');
		}else{
			that.text(thatDataTitle);
			that.data('title','');
		}

		additionalLIst.slideToggle();

	});
	// New Requests - user click I'm on it button
	$('.newtivits .on-it').live('hover', function(){
		$(this).css('cursor','pointer');
	});
			
	$('.newtivits .on-it').live('click', function(){
		
		 // find out the tivit id that was clicked on
	    var record = jQuery(this).parents('.record');
	    var tivitID = $(record).find("input").attr("tivitid");
	    console.log ("[Yaniv] on-it tivitid=", tivitID);
	    		
		var record = $(this).parents('li.record:first')
		var recordHTML = record.html();
		//var appendHTML = "<div class='team tivits fresh-tivits' style='display:none'><div class='tvit-list'><ul class='list'><li class='record unread'>"
		//					+ recordHTML +
		//				 "</li></ul></div></div>";

		// Now we need to tuggle the hidden I'm on it tivit and tell it to show up 
		
		// This will bring the tivit record based on all the input elements that has the tivitid attrivute equal to the tivit id in hand. Good examples here: http://www.mkyong.com/jquery/jquery-attribute-selector-examples/
		var tivitRecord = $("input[tivitid='" + tivitID + "']").parents('.record');
		// Just testing we found the right one
		var foundtivitID = $(tivitRecord).find("input").attr("tivitid");
		console.log ("[Yaniv] on-it foundtivitID=", foundtivitID);
		
		// add the yellow background to show newly added
		tivitRecord.find('.conteiner').addClass('yell-bg').removeClass('record-hovered').removeClass('no-hover');
		
		// Make an Ajax call to update the status of the tivit to on-it!
		var action = '/onit?id=' + tivitID + '&method=post';
		
		console.log ("[Yaniv] action=", action);
		
		// Actual Ajax call to the controller
		$.post(action, $(this).serialize(), null, "script");	
		console.log ("[Yaniv] after Ajax call");
		
		// Original jQuery from Artem
		//$('#tivit-desk .team:last').after($(appendHTML));
		//$('.fresh-tivits .want-help').remove();
		//$('.fresh-tivits .calendar').remove();
		//$('.fresh-tivits .activity').html("<div class='comments'></div>").removeAttr('style');
		//$('.fresh-tivits .conteiner').addClass('yell-bg').removeClass('record-hovered').removeClass('no-hover');

		$(record).slideUp(function(){
			$(this).remove();
			$('.fresh-tivits').slideDown();
			recalculateNewRequests();
		});
		
		
		
		// The new and reviewed tivits were already rendered in the right place in the HTML but hidden. Now that the user said on-it, let's just show it 
		tivitRecord.show();
		
		function recalculateNewRequests(){
			var newtivitQty = $('.newtivits .record').length;
	
			if(newtivitQty == 0){
				$('.newtivits').slideUp(function(){
					$(this).remove();
				});
			}else{
				$('.newtivits .qty').text(newtivitQty);
			}
		}
	
	
	});
	
	/*
	$('.conteiner').live('mouseover mouseout', function(event) {
	  if (event.type == 'mouseover') {
	    // do something on mouseover
	    $(this).addClass('record-hovered');
	    //$(this).children('.edit-menu').children('.icon').toggle();
	    //   console.log ("[Yaniv] mouse ON container");
	  } else {
	    // do something on mouseout
	    $(this).removeClass('record-hovered');
	   // $(this).children('.edit-menu').children('.icon').toggle();
	    //console.log ("[Yaniv] mouse OUT container");
	    //$(this).children('.menu-dialog').toggle();
	  }
	});
	*/ 	
	/***********************************************************************************************/
	// tivit status checkbox
    //var statusIcon = jQuery('.status .icon');
    var respondStatus = jQuery('.respond .form-button'); 
    var statusIcon = jQuery('.status .icon');
     
    // status icon on each tivit on the left AND in the respond button
    statusIcon.live('click',function(){
    	showStatusListDialog (this);    	
    });
    
    // respond button - click should open the status menu
	respondStatus.live('click',function(){
    	showStatusListDialog (this);   	
    });
    /***********************************************************************************************/
	// Hide open menu dialogs (such as status change, edit/delete, etc.)
     $('body').click(function(event) {

         // status dropdown list
         if (!jQuery(event.target).closest('.status-list-dialog').length && jQuery('.status-list-dialog').is(':visible')) {
             jQuery('.status-list-dialog').remove();
         }
         // user dropdown menu
         else if(!jQuery(event.target).closest('#user-nav').length && jQuery('#sm_1').is(':visible')){
        	 jQuery('#sm_1').hide();
         }
         // edit / delete menu
         else if(!jQuery(event.target).closest('.menu-dialog').length && jQuery('.menu-dialog').is(':visible')){
        	 jQuery('.menu-dialog').hide();
         }
     });
	/***********************************************************************************************/
	// change tivit status checkbox
	var statusCh = jQuery('.status-list-dialog .status-list li');
    statusCh.live('click',function(){
	
		var tivitobject = jQuery(this).parent().parent().parent(); 
		var tivitID = tivitobject.find("input").attr("tivitid");
    	console.log ("[Yaniv] status dropdown: tivitID=", tivitID);
    	
    	record = jQuery(this).parents('.record');
    	newState = jQuery(this).attr('class');
    	newClassValue = 'record ' + newState;
    	console.log ("[Yaniv] newState=", newState);
    	var dueDate = "";
    	var who = "";
    	//console.log(newState=='complete');
    	//if(newState=='inprog' || newState=='complete'){
    		switch(newState){
	    		case 'inprog':
	    			console.log('[Yaniv] tivit status change - ON IT -');
	    			var confirmDialogTitle = 'I\'m on it!';
	    			//var confirmDialogText = 'Want to add a comment or attach file?';
	    			var actionPost = 'action="/onit?id=' + tivitID + '&method=post"' + ' accept-charset="UTF-8">';
	    			break;
	    		case 'complete':
	    			console.log('[Yaniv] tivit status change - COMPLETE -');
	    			var confirmDialogTitle = 'I\'m Done!';
	    			var actionPost = 'action="/done?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			break;
	    		case 'busy':
	    			console.log('[Yaniv] tivit status change - BUSY/CANNOT DO IT -');
	    			var confirmDialogTitle = 'Sorry, I can\'t help';
	    			var actionPost = 'action="/decline?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			break;
	    		case 'attention':
	    			console.log('[Yaniv] tivit status change - ATTENTION -');
	    			var confirmDialogTitle = 'Propose Another Date';
	    			var actionPost = 'action="/proposedate?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			dueDate = '<p class="input-date"><label for="propose_date">How about:</label>' +
									'<input id="propose_date" name="propose_date" type="text" autocomplete="off" placeholder="choose date" class="required tivitiDate"/>' + 
								    '<img src="/images/cal.gif" onclick="javascript:NewCssCal(\'propose_date\', \'mmddyyyy\', \'arrow\', false,\'24\', true,\'future\' )" class="ico_calc"/>' +
							  '</p>';			           
	    			break;
	    		case 're-assign':
	    			console.log('[Yaniv] re-assign tivit selected.');
	    			var confirmDialogTitle = 'Reassign task to someone else';
	    			var actionPost = 'action="/reassign?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
					who = '<p><label for="who">Who:</label><input type="text" name="assign_to" id="assign_to" placeholder="- enter one email address -" class="required email" /></p>';    
	    			break;
	    			
	    		case 'unread':
	    			// basically this won't work now until I get a function from Ilan for the controller....
	    			console.log('[Yaniv] tivit status change - UNREAD/WHITE COLOR -');
	    			//var confirmDialogTitle = 'Not on it now...';
	    			//var actionPost = 'action="/onit?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			 jQuery('.status-list-dialog').remove();
	    			 return;
	    			break;
	    			
    		}
			
    		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    								'<input type="hidden" newstate="' + newState + '">' + 
    								'<div class="loading-popup"></div>' + 
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											who + 
											'<p><textarea rows="10" cols="10" id="comment" name="comment" placeholder="- enter a message here if you\'d like... -"/></p>' +
											dueDate + 
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';				

		
			//$($('#confirmDialog').css('h3')).css('background', 'none');	
			$('#confirmDialog').css('margin-top',($('body').height() - $('.popup').height()) / 20);
			 /*
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
			 */
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 jQuery('#activity-overlay').show();
    		 jQuery(this).parents('.record').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '-70px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');
    		 jQuery('.status-list-dialog').remove();
    		 
    		 if (who != "")
    		 {
	    		 // autocomplete for reassign
				 jQuery("input[id=assign_to]").autocomplete({
			  	 	source: '/ajax/invitees',
			  		 minLength: 2
				 });
			 }
	    	
	    	// Validate date only for propose new date case
	    	if ( newState == 'attention' )
	    	{  		
	    		$("#confirmDialogForm").validate({
	  				rules : {
	      				myDate : { tivitiDate : true }
	   				}
				});
			}


    		 // Add validation in case of re-assign (we have email input)
    		 //if (newState == 're-assign')
    		 //{
    		 
    		 $("#confirmDialogForm").validate({
	    		 	  				           			
			 	submitHandler: function(form) {
					console.log ('[Yaniv] confirm dialog submit button clicked!');
					showLoadingAnimation('.loading-popup');
					var actionparam = $(this).attr("action") + "";
					console.log('[Yaniv] action=', actionparam);
						
					$.post($(form).attr("action"), $(form).serialize(), function() { hideLoadingAnimation ('.loading-popup');}, "script");
						
					// Find the new status we need to change the checkbox to, it's hidden in the HTML of the confirmation popup.
					var statusobject = jQuery(form).parents('.popup'); 
					
					var newStateVal = statusobject.find("input").attr("newstate");
					if (newStateVal == "complete")	
					{
						var newState = 'record ' + statusobject.find("input").attr("newstate") + ' tivit-name-line-through';
					}
					else
					{
						var newState = 'record ' + statusobject.find("input").attr("newstate");
					}
				    //console.log ("[Yaniv] new state=", newState);
					record = jQuery(form).parents('.record');
					// Change status on UI to the new selected state (need to use this for Ajax callback)
					
					record.attr('class', newState);
						
					// Show comment of status change
					addNewComment (record);
					
					// Update respond button text
					updateRespondButtonText (record, statusobject.find("input").attr("newstate"));
						
					return false;
				}     
			});
				
			function updateRespondButtonText (record, state)
			{
					//console.log ("Respond Button:: state=", state);
					var newRespondButtonText = "Yaniv";
						
					switch(state){
			    		case 'inprog':
			    			newRespondButtonText = 'I\'m on it!';
			    			break;
			    		case 'complete':
			    			newRespondButtonText = 'I\'m done!';
			    			break;
			    		case 'busy':
			    			newRespondButtonText = 'can\'t help';
			    			break;
			    		case 'attention':
			    			newRespondButtonText = 'new date?';
			    			break;
			    		case 're-assign':
			    			break;
			    			
			    		case 'unread':
			    			newRespondButtonText = 'respond';
			    			break;
	    		
    				}
                        
					record.find ('.respond .form-button').text(newRespondButtonText);			
				}
	
			//}
    	 //}
    	 //else
    	// {
    	//	 jQuery('.status-list-dialog').remove();
    	//	 record.attr('class',newClassValue);
    	// }

		/************************************************************/
		// close popup that is currently opened */
		$('.popup .close').click(function(){
			console.log ('[Yaniv] NEW--- popup close button clicked')
			hidePopup();
			
		});	
		
		$('#popup-cancel').click(function(){
			console.log ('[Yaniv] popup cancel clicked')
			hidePopup();
		});
	
	 //jQuery("#confirmDialogForm").submit(function() {
	//	console.log ('[Yaniv] confirm dialog submit button clicked!');
	//	showLoadingAnimation('.loading-popup');
	//	var actionparam = $(this).attr("action") + "";
	//	console.log('[Yaniv] action=', actionparam);
		
	//	$.post($(this).attr("action"), $(this).serialize(), function() { hideLoadingAnimation ('.loading-popup');}, "script");
		
		// Find the new status we need to chagen the checkbox to, it's hidden in the HTML of the confirmation popup.
	//	var statusobject = jQuery(this).parents('.popup'); 
		//console.log ("[Yaniv] statusobject=", statusobject);
	//	var newState = 'record ' + statusobject.find("input").attr("newstate");
    	//console.log ("[Yaniv] new state=", newState);
	//	record = jQuery(this).parents('.record');
	//	record.attr('class', newState);
		
	//	return false;
	// });
	 
	 
	
	 	
	});
    /************************************************************/
     /*
     jQuery('.confirmDialog .cancel-button').live('click', function(){
     	console.log ('[Yaniv] confirm dialog CANCEL button clicked!');
         jQuery('.confirmDialog').remove();
         jQuery('#activity-overlay').fadeOut();
         jQuery('#new-activity-background').removeClass('tempHide');
     });
     jQuery('.confirmDialog .submit-button').live('click', function(){
         jQuery('.confirmDialog').remove();
         jQuery('#new-activity-background').removeClass('tempHide');
         jQuery('#new-activity-background .input-name').focus();
     });
     */
     
 });
function openEdittivitDialog (clickedObject)
{
	var record = jQuery(clickedObject).parent();
	//console.log ("[Yaniv] in opentivitDialog func.");
	
	jQuery(clickedObject).parents('.menu-dialog').toggle();
		
	jQuery('#activity-overlay').show();
	/* Yaniv - clear the form before creating new tivit **/
	//$("#create-new-tivit-form")[0].reset();
	/*****************************************************/
	//$('#add-tivit-window').show();
		
	var record = jQuery(clickedObject).parents('.record')
	var tivitID = record.find("input").attr("tivitid");
    console.log ("[Yaniv] edit tivit: tivitID=", tivitID);
	var action = '/edit_tivit?id=' + tivitID;
	console.log ("[Yaniv] action=", action);
		
	jQuery.post(action, jQuery(clickedObject).serialize(), null, "script");		
		
	return false;
	
}
// Insert new comment dummy after status change so it can be updated by eash status .js.erb file
function addNewComment (record)
{
	console.log ('[Yaniv] addLastComment(record):: called.');
			
	var tivitID = record.find("input").attr("tivitid");
	console.log ("[Yaniv] addLastComment(record):: tivitID=", tivitID);
	var lastPost = record.find ('.post');
	var newcommentId = "newcomment" + tivitID;
				
	var newComment = '<li class="record" id="' + newcommentId + '"></li>';
	console.log ('[Yaniv] newComment=', newComment);
			
	lastPost.before(newComment);
			
	console.log ('[Yaniv] addLastComment(record):: END.');
}
				
function showStatusListDialog(clickedObject){
    	
    	//var tivitobject = jQuery(this).parent();
     	//console.log ("[Yaniv] tivitobject=", tivitobject);
     	
     	var mytivit = jQuery(clickedObject).parent().find("input").attr("mytivit");
    	var activityOwner = jQuery(clickedObject).parent().find("input").attr("activityOwner");
		var invitedByMe = jQuery(clickedObject).parent().find("input").attr("invitedByMe");
		
		console.log ("[Yaniv] mytivit=", mytivit);
		console.log ("[Yaniv] activityOwner=", activityOwner);
		console.log ("[Yaniv] invitedByMe=", invitedByMe);
		    	
    	
    	var statusList = '';
    	
    	if (mytivit == "yes" && invitedByMe != "yes")
    	{
    		statusList = '<div class="status-list-dialog">'+
                        '<ul class="status-list">'+
                            //'<li class="unread"><div class="ico"></div>Not started</li>'+
                            '<li class="inprog"><div class="ico"></div>I\'m on it</li>'+
                            '<li class="complete"><div class="ico"></div>I\'m done!</li>'+
                            '<li class="busy"><div class="ico"></div>Sorry, I can\'t help</li>'+
                            '<li class="attention"><div class="ico"></div>Propose new date</li>'+
                            '<li class="re-assign"><div class="ico"></div>Reassign</li>'+
                        '</ul>'+
                     '</div>';
        }
        // I created tivit for myself
        else if ( mytivit == "yes" && invitedByMe == "yes" )
        {
         		statusList = '<div class="status-list-dialog">'+
                        '<ul class="status-list">'+
                            //'<li class="unread"><div class="ico"></div>Not started</li>'+
                            '<li class="inprog"><div class="ico"></div>I\'m on it</li>'+
                            '<li class="complete"><div class="ico"></div>I\'m done!</li>'+
                            '<li class="re-assign"><div class="ico"></div>Reassign</li>'+
                        '</ul>'+
                     '</div>';
    	}
        else if ( activityOwner == "yes" || invitedByMe == "yes" )
        {
         		statusList = '<div class="status-list-dialog">'+
                        '<ul class="status-list">'+
                            //'<li class="unread"><div class="ico"></div>Not started</li>'+
                            //'<li class="inprog"><div class="ico"></div>I\'m on it</li>'+
                            '<li class="complete"><div class="ico"></div>I\'m done!</li>'+
                            '<li class="re-assign"><div class="ico"></div>Reassign</li>'+
                        '</ul>'+
                     '</div>';
    	}
    	//else
    	//{ 
     	//  statusList = '<div class="status-list-dialog">'+
        //                '<ul class="status-list">'+
        //                   //'<li class="unread"><div class="ico"></div>Not started</li>'+
        //                    '<li class="inprog"><div class="ico"></div>I\'m on it</li>'+
        //                    '<li class="complete"><div class="ico"></div>I\'m done!</li>'+
        //                    '<li class="busy"><div class="ico"></div>Sorry, I can\'t help</li>'+
        //                    '<li class="attention"><div class="ico"></div>Propose new date</li>'+
        //                    '<li class="re-assign"><div class="ico"></div>Reassign</li>'+
        //                '</ul>'+
         //            '</div>';
         //}            
     	// Check if the user owns this tivit or not. If not, don't allow to change status therefor dropdown will not open
		    	    	
     	if (mytivit == "yes" || activityOwner == "yes" || invitedByMe == "yes" )
     	{	
	    	var recState = jQuery(clickedObject).closest('li');
	    		console.log(recState.attr('class'));
		    	if(recState.hasClass('unread'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		jQuery('.status-list-dialog').find('.unread').remove();
		    		jQuery('.status-list-dialog').show();
		    	}
		    	else if(recState.hasClass('inprog'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		jQuery('.status-list-dialog').find('.inprog').remove();
		    		jQuery('.status-list-dialog').show();
		    	}
		    	else if(recState.hasClass('complete'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		jQuery('.status-list-dialog').find('.complete').remove();
		    		jQuery('.status-list-dialog').show();
		    	}
		    	else if(recState.hasClass('busy'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		//jQuery('.status-list-dialog').find('.busy').remove();
		    		jQuery('.status-list-dialog').show();
		    	}
		    	else if(recState.hasClass('attention'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		jQuery('.status-list-dialog').find('.attention').remove();
		    		jQuery('.status-list-dialog').show();
		    	}
		    	else if(recState.hasClass('re-assign'))
		    	{
		    		jQuery(clickedObject).parent().append(statusList);
		    		jQuery('.status-list-dialog').show();
		    	}
		}
	}

function hideInlineLoadingAnimation(){
	console.log ('[Yaniv] hideInlineLoadingAnimation called.');
	jQuery('.loading').hide();
	//alert ('hideLoadingAnimation called.');
}
function showInlineLoadingAnimation(){
	console.log ('[Yaniv] showInlineLoadingAnimation called.');
	//alert ('showLoadingAnimation called.');
	jQuery('.loading').show();
}
function showLoadingAnimation(classorid){
	console.log ('[Yaniv] showLoadingAnimation with:', classorid);
	//alert ('showLoadingAnimation called.');
	jQuery(classorid).show();
}
function hideLoadingAnimation(classorid){
	//alert ("callback is back!");
	console.log ('[Yaniv] hideLoadingAnimation with:', classorid);
	//alert ('showLoadingAnimation called.');
	jQuery(classorid).hide();
}

/* Not in use */
function removePopup(){
	console.log ('[Yaniv] Closing popup');
	jQuery('.popup').remove();
	jQuery('#new-activity-background').removeClass('tempHide');
	jQuery('#activity-overlay').fadeOut();
}
/**************/

function hidePopup(){
	console.log ('[Yaniv] Hiding Popup');
	// Confirmation dialog div HAS to be removed form the page, but popup should be hidden since I'm using it for add tivit which is on the view/server side
	jQuery('#confirmDialog').remove();
	jQuery('#edit-tivit-popup').remove();
	
	jQuery('#wholine').show();
	
	// Make sure the new tivit dialog always have the assign to myself unchecked and the input field for invitees is zero'd out
	jQuery('#invitees').val('');
	jQuery('#assignmyselfchk').removeClass('active');
			
	jQuery('.popup').hide();
	jQuery('#activity-overlay').fadeOut();
	jQuery('#new-activity-background').removeClass('tempHide');
	hideLoadingAnimation('.loading-popup');
}
function openNewActivity(){
    var layer = jQuery('#new-activity-complete');

	// Check if new activity FTE bubble is shown. If yes, hide it for now...
	if (jQuery("#newactivityFTE").is(":visible"))
    {
    	jQuery("#newactivityFTE").hide();
    }
    
    if (jQuery("#dashboardFTE").is(":visible"))
    {
    	jQuery("#dashboardFTE").hide();
    }
    
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
		if (jQuery("#newactivityFTE").is(":hidden"))
   		{
    		jQuery("#newactivityFTE").fadeIn();
    	}
    	if (jQuery("#dashboardFTE").is(":hidden"))
   		{
    		jQuery("#dashboardFTE").fadeIn();
    	}
    });    
    
    jQuery(':input','#new-activity-form')
    .not(':button, :submit, :reset, :hidden')
    .val('')
    .removeAttr('checked')
    .removeAttr('selected');
    jQuery('#new-activity-form textarea').val('');
    
    
}
/***********************************************************************************************************************************************************/
// Scripts for Activity Page
// from Irina Sorokina (sorokina333@gmail.com)
jQuery(document).ready(function($){
 	
 	// autocomplete for new tivit. Example taken from http://stackoverflow.com/questions/6245161/jquery-ui-autocomplete-rails3-and-cancan-model-access-problem
 	jQuery("input[id=invitees]").autocomplete({
  		source: '/ajax/invitees',
  		minLength: 2
	});
	
	//'<p><label for="who">Who:</label><input type="text" name="assign_to" id="assign_to" placeholder="- enter one email address -" class="required email" /></p>';    
	

 	// Validate form input before submission to make sure we don't send crap to the server!
 	$("#create-new-tivit-form").validate({
   		//debug: true,
   		submitHandler: function(form) {
	     	console.log ('[Yaniv] #create-new-tivit-form clicked');
			showLoadingAnimation('.loading-popup');
			console.log ('[Yaniv] after loading animation...');
			$.post($(form).attr("action"), $(form).serialize(), function() { hideLoadingAnimation ('.loading-popup');}, "script");
			return false;
     	}     
	});
 	
	var description = $('.description p span').text();
	
	console.log('in Irina DOM Ready function');  
	/************************************************************/
	// add a tivit popup
	$('#add-tivit').click(function(){
		console.log ('[Yaniv] add a tivit button clicked');
		jQuery('#activity-overlay').show();
		/* Yaniv - clear the form before creating new tivit **/
		$("#create-new-tivit-form")[0].reset();
		/*****************************************************/
		$('#add-tivit-window').show();
		/**** Yaniv **** this should be commented out so the choose date in the new tivit popup can be empty
		var myDate = new Date();
		var prettyDate =(myDate.getMonth()+1) + '/' + (myDate.getDate()+1);
		$('#due').val('tommorrow ' + '(' + prettyDate + ')');
		*/
	});	
	/************************************************************/
	// close create new activity layer that is currently opened */
	$('.popup .close').click(function(){
		console.log ('[Yaniv] Create new actvity popup CLOSE button clicked')
		hidePopup();
	});	
	$('#cancel').click(function(){
		console.log ('[Yaniv] Create new actvity CANCEL clicked')
		hidePopup();
	});
	/************************************************************/
	//assign myself
	$('.popup .assign').click(function(){
		if($(this).is('.active')){
			$(this).removeClass('active');
			//$('#who').val('').removeAttr('disabled');
			$('#wholine').show();
		} else {
			$(this).addClass('active');
			$('#wholine').hide();
			//$('#who').val('don.drapper@sterlingcooper.com').attr('disabled','disabled');
			$('#invitees').val('');
		}
	});
	
	/* Yaniv - Show/Hide comments when clicking on a tivit */
	$('.text-conteiner').live('click', function(e){
		//alert($(this).parents('.record').children('ul').attr('class'));
		//console.log('[Yaniv] tivit clicked - show/hide comments...');
		
		// This is used to isolate clicks on remind hyperlink on ADP page in each tivit, without this, the remind link will not work
		if( $(e.target).is("a") ){
			console.log("Run function because clicking on something else");
			return;
		}
		
		// Mark any un-read comments as read 
		
		// First, check if we're opening or closing comments. Only on open we need to update the server
		if (!jQuery(this).parents('.record').children('ul').is(":visible"))
	    {
	        console.log ("[Yaniv] OPEN comments!");
	        
	        // Check if there're new comments on this activity by looking on the UI, if there's a red cricle of new comments
	        var record = jQuery(this).parents('.record');
	        // The red circle is in the <i> element
	        var newComments = record.find('i');
	        // Check if we found anything, if not, that means no new comments
	        if (newComments.length != 0 )
	        {
	        	console.log ("[Yaniv] new comments =", newComments.text() ); 
	        	var tivitID = record.find("input").attr("tivitid");
	    		console.log ("[Yaniv] comments expanded tivit: tivitID=", tivitID);
				
				var action = '/update_reviewed/' + tivitID;
				console.log ("[Yaniv] action=", action);
				// Mark any un-read comments as read 
				$.post(action, $(this).serialize(), null, "script");	
				
				// remove the red circle since comments are red
				newComments.fadeOut();
	        }
	        else
	        {
	        	console.log ("[Yaniv] NO new comments!"); 
	        }
	    }
	    else
	    {
	    	console.log ("[Yaniv] CLOSE comments!");
	    }
	    
		$(this).parents('.record').children('ul').fadeToggle('slow');
		//$(this).parents('.record').children('.show-more').fadeToggle('slow');
		$(this).parents('.record').children('.respond').fadeToggle('slow');
			
		return false;
		
	});	
	//$('.text-conteiner').hover(function(){
	$('.text-conteiner').live('hover', function(e){
		//alert($(this).parents('.record').children('ul').attr('class'));
		//console.log('[Yaniv] tivit clicked - show/hide comments...');
		
		// This is used to isolate clicks on remind hyperlink on ADP page in each tivit, without this, the remind link will not work
		if( $(e.target).is('.gray') ){
			console.log("Run function because clicking on something else");
			return;
		}
		else
		{		
			$(this).css('cursor','pointer');
		}
	});
	//$('.text-conteiner').live('mouseover mouseout', function(event) {
	//  if (event.type == 'mouseover') {
	    // do something on mouseover
	//    $(this).css('cursor','pointer');
	//  } else {
	    // do something on mouseout
//	  }
	//});
	
	
	/* Clicking comments icon opens comments */
	$('.comments').live('click', function(){
		//alert($(this).parents('.record').children('ul').attr('class'));
		//console.log('[Yaniv] tivit clicked - show/hide comments...');
		// Mark any un-read comments as read 
		
		// First, check if we're opening or closing comments. Only on open we need to update the server
		// Also, second section in the if is to ignore the click on the dashboard page and make sure it only works on ADP page
		//&& !jQuery(this).parents('.record').not('.tivits .record').not('.main-tivit')
		if (!jQuery(this).parents('.record').children('ul').is(":visible"))
	    {
	        console.log ("[Yaniv] OPEN comments!");
	        
	        // Check if there're new comments on this activity by looking on the UI, if there's a red cricle of new comments
	        var record = jQuery(this).parents('.record');
	        // The red circle is in the <i> element
	        var newComments = record.find('i');
	        // Check if we found anything, if not, that means no new comments
	        if (newComments.length != 0 )
	        {
	        	console.log ("[Yaniv] new comments =", newComments.text() ); 
	        	var tivitID = record.find("input").attr("tivitid");
	    		console.log ("[Yaniv] comments expanded tivit: tivitID=", tivitID);
				
				var action = '/update_reviewed/' + tivitID;
				console.log ("[Yaniv] action=", action);
				// Mark any un-read comments as read 
				$.post(action, $(this).serialize(), null, "script");	
				
				// remove the red circle since comments are red
				newComments.fadeOut();
	        }
	        else
	        {
	        	console.log ("[Yaniv] NO new comments!"); 
	        }
	    }
	    else
	    {
	    	console.log ("[Yaniv] CLOSE comments!");
	    }
	    
		$(this).parents('.record').children('ul').fadeToggle('slow');
		//$(this).parents('.record').children('.show-more').fadeToggle('slow');
		$(this).parents('.record').children('.respond').fadeToggle('slow');
		
	});	
	//$(".record").not('.tivits .record').not('.main-tivit').hover(
		
	$('.comments').hover(function(){
		//if (jQuery(this).parents(".record").not('.tivits .record').not('.main-tivit'))
		//{
			$(this).css('cursor','pointer');
		//}
	});
	/*
	//change respond status
	$('.respond .form-button').live('click', function(){
	
		var respondList = 	'<div class="status-list-dialog menu-dialog">' +
							'<ul class="status-list">' +
								'<li class="inprog"><div class="ico"></div>I\'m on it</li>' +
								'<li class="complete"><div class="ico"></div>I\'m finished</li>' +
								'<li class="busy"><div class="ico"></div>I\'m too busy</li>' +
								'<li class="attention"><div class="ico"></div>Propose new date</li>' +
							'</ul>' +
						'</div>';

		$(this).parent().append(respondList);
		$(this).next().addClass('visible');
	});
	*/
	$('.respond li').live('click', function(){
		//alert($(this).parent().parent().parent().first().attr('class'));
		//$(this).parent().parent().prev().text($(this).text());
	});
	
	//edit menu
	$('.edit-menu').live('click', function(){
		$(this).children('.menu-dialog').toggle();
	});
	
	//truncate off description in main part
	$('.description .more').click(function(){
		//alert(description);
		$('.description').html('<p><span>' + description +
		'</span><small class="less">Don Drapper 5 min ago</small>'+
		'<a class="more less" href="#">show less</a></p>');
	});
	
	$('.description .less').live('click', function(){
		$('.description p span').truncate({
			width: '1100',
			after: '&hellip;'
		});
		$('.description small').removeClass('less');
		$('.description a').removeClass('less').text(' more ');
	});
	
	//Show more or less comments
	$('.show-more').click(function(){
		var list = $(this).next().children();
		var commentsCount = list.length - 2;
		
		if($(this).hasClass('open')){
			$(this).removeClass('open').html('<a href="#">Show '+commentsCount+' more comment</a>');
			if(list.length > 2 ){
				list.each(function(){
					$(this).addClass('invisible');
				});
				list.last().removeClass('invisible').addClass('visible');
				list.last().prev().removeClass('invisible').addClass('visible');
			}
		} else {
			$(this).addClass('open').html('<a href="#">Show fewer comments</a>');		
			list.each(function(){
				$(this).removeClass('invisible');
			});
		}
		return false;
	});
	
	// add a comment - show post button 
	$('.post textarea').live('click', function(){
		if($(this).parent().is('.post-style')){
			return false
		}else{
			$(this).val('');
			$(this).parent().addClass('post-style')
			// The line below include attach a file link, commented for now.
			//.append('<p><input type="submit" value="Post" class="post-button"><a href="#" class="attach-file">attach a file</a></p>');
			.append('<p><input type="submit" value="Post" class="post-button"></p>');
		}
	});
	//Or don't do anything BUG
	$('.post-style').live('mouseleave', function(){
		//$(this).removeClass('post-style').html('<textarea cols="10" rows="1">Leave a note...</textarea>');
	});
	
	/***********************************************************************************************/
	jQuery('.icon').hover(		
		function() {
	       $(this).css('cursor','pointer');
	   },
	   function() {
	      $(this).css('cursor','none');
	   }	 	
	);
	/* edit tivit on ADP */
	$('.edit').live('click', function(){
		openEdittivitDialog (this);
	});
	/* edit tivit on ADP */
	$('.activity .calendar').live('click', function(){
		console.log ("[Yaniv] calendar clicked.");
		
		var mytivit = jQuery(this).parents().find("input").attr("mytivit");
    	var activityOwner = jQuery(this).parents().find("input").attr("activityOwner");
		var invitedByMe = jQuery(this).parents().find("input").attr("invitedByMe");
		
		console.log ("[Yaniv] mytivit=", mytivit);
		console.log ("[Yaniv] activityOwner=", activityOwner);
		console.log ("[Yaniv] invitedByMe=", invitedByMe);
		if ( activityOwner == "yes" || invitedByMe == "yes")
		{
			openEdittivitDialog (this);
		}
		
	});
	
	jQuery('.activity .calendar').hover(		
		function() {
		
			var mytivit = jQuery(this).parents().find("input").attr("mytivit");
    	var activityOwner = jQuery(this).parents().find("input").attr("activityOwner");
		var invitedByMe = jQuery(this).parents().find("input").attr("invitedByMe");
		
		console.log ("[Yaniv] mytivit=", mytivit);
		console.log ("[Yaniv] activityOwner=", activityOwner);
		console.log ("[Yaniv] invitedByMe=", invitedByMe);
		if ( activityOwner == "yes" || invitedByMe == "yes")
		{
			$(this).css('cursor','pointer');
	    }
	    else
	    {
	    	$(this).css('cursor','default');
	    }
	   },
	   function() {
	      $(this).css('cursor','default');
	   }	 	
	);
			
	/*
	jQuery("#edit-tivit-form").live('submit', function() {
		console.log ('[Yaniv] #edit-tivit-form submit clicked');
		showLoadingAnimation('.loading-popup');
		$.post($(this).attr("action"), $(this).serialize(), hideLoadingAnimation ('.loading-popup'), "script");
		return false;
	});
	*/
	
	/* delete tivit */
	$('.del').live('click', function(){
		var record = $(this).parent();
		console.log ("[Yaniv] edit tivit clicked.");
	
		$(this).parents('.menu-dialog').toggle();
		
		// Show overlay screen
		jQuery('#activity-overlay').show();
		
		var record = jQuery(this).parents('.record')
		var tivitID = record.find("input").attr("tivitid");
    	console.log ("[Yaniv] delete tivit: tivitID=", tivitID);
			
		var actionPost = 'action="/remove_tivit?id=' + tivitID + '&method=post"' + ' accept-charset="UTF-8">';
		
		console.log ("[Yaniv] action=", actionPost);
		var confirmDialogTitle = "Sure you want to delete this task?";
		
		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    								'<div class="loading-popup"></div>' + 
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p> We assume you do but just wanted to ask you one more time since we won\'t be able to recover this for you... </p>'+
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 jQuery('#activity-overlay').show();
    		 jQuery(this).parents('.record').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '-70px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');
		
		return false;
	});
	
		
		$('#popup-cancel').live('click', function(){
			console.log ('[Yaniv] popup cancel clicked')
			hidePopup();
		});
		
	 //jQuery('.confirmDialog .cancel-button').live('click', function(){
	 /************************************************************/
		// close popup that is currently opened */
		$('.popup .close').live('click', function(){
			console.log ('[Yaniv] EDIT TIVIT--- popup close button clicked')
			hidePopup();
			
		});	
		
		$('#cancel').live('click', function(){
			console.log ('[Yaniv] popup cancel clicked')
			hidePopup();
		});
		
	//delete comment
	$('.delete').live('click', function(){
		var record = $(this).parent();
		record.slideUp('slow');
		setTimeout(function(){record.remove();},3000);
		return false;
	});
	
	jQuery('.grey .proposed_date').live('click', function(){
	 	console.log ("[Yaniv] status line accept clicked.");
	 	return false;
	 	
	});
	/////////////////////////////////////////////////////////////////////////
	// send reminder in tivit status line
	jQuery('.grey .send-reminder').hover(		
		function() {
	      //$(this).css('cursor','pointer');
	      //console.log ("[Yaniv] status line accept hovered.");
	      $(this).css('text-decoration','underline');
	      $(this).css('cursor','pointer');
	   },
	   function() {
	   	//console.log ("[Yaniv] status line accept un-hovered.");
	      $(this).css('text-decoration','none');
	      $(this).css('cursor','none');
	   }	 	
	);
	// Send Reminder clicked
	jQuery('.grey .send-reminder').live('click', function(){
	 	
	 	//console.log ("[Yaniv] status line accept clicked.");	
		
		var record = jQuery(this).parents('.record');
		var tivitID = record.find("input").attr("tivitid");
    	console.log ("[Yaniv] send reminder tivitID=", tivitID);
			
		var actionPost = 'action="/remind?id=' + tivitID + '&method=put"' + ' accept-charset="UTF-8">';
		
		console.log ("[Yaniv] ", actionPost);
		var confirmDialogTitle = "Send Reminder (email)";
		
		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    								'<div class="loading-popup"></div>' + 
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p><textarea rows="10" cols="10" id="comment" name="comment" placeholder="- enter a message here if you\'d like... -"/></p>' +
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 // Show overlay screen
    		 jQuery('#activity-overlay').show();
    		
    		 jQuery(this).parents('.record').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '-70px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');
		
		return false;
 	
	});
	
	/////////////////////////////////////////////////////////////////////////
	// accept new proposed date in tivit status line
	jQuery('.grey .accept-proposed').hover(		
		function() {
	      //$(this).css('cursor','pointer');
	      console.log ("[Yaniv] status line accept hovered.");
	      $(this).css('text-decoration','underline');
	      $(this).css('cursor','pointer');
	   },
	   function() {
	   	console.log ("[Yaniv] status line accept un-hovered.");
	      $(this).css('text-decoration','none');
	      $(this).css('cursor','none');
	   }	 	
	);
	
	// Accept clicked
	jQuery('.grey .accept-proposed').live('click', function(){
	 	console.log ("[Yaniv] status line accept clicked.");	
		
		var record = jQuery(this).parents('.record');
		var tivitID = record.find("input").attr("tivitid");
    	console.log ("[Yaniv] accept new date tivitID=", tivitID);
			
		var actionPost = 'action="/acceptdate?id=' + tivitID + '&method=put"' + ' accept-charset="UTF-8">';
		
		console.log ("[Yaniv] ", actionPost);
		var confirmDialogTitle = "Accept new proposed date";
		
		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    								'<div class="loading-popup"></div>' + 
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p><textarea rows="10" cols="10" id="comment" name="comment" placeholder="- enter a message here if you\'d like... -"/></p>' +
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 // Show overlay screen
    		 jQuery('#activity-overlay').show();
    		
    		 jQuery(this).parents('.record').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '-70px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');
		
		return false;
 	
	});
	/////////////////////////////////////////////////////////////////////////
	
	// status icon mouse status. Only show pointer when dropdown will actually open
	$('.icon').live('hover', function(){
		var mytivit = jQuery(this).parent().find("input").attr("mytivit");
		var activityOwner = jQuery(this).parent().find("input").attr("activityOwner");
		var invitedByMe = jQuery(this).parent().find("input").attr("invitedByMe");
				
		if (mytivit == "yes" || activityOwner == "yes" || invitedByMe == "yes")
		{
			$(this).css('cursor','pointer');
		}
		else
		{
			$(this).css('cursor','default');
		}
			
	});
	/////////////////////////////////////////////////////////////////////////
	// Edit Activity - ADP
	jQuery('.edit-yaniv').live('click', function(){
		console.log ("[Yaniv] edit activity clicked!");	
				
		var record = jQuery(this).parents('.act-main');
		var activityID = record.find("input").attr("activityid");
    	console.log ("[Yaniv] activityid=", activityID);
    	
		var actionPost = '/activities/' + activityID + '/edit';
								
		jQuery('#activity-overlay').show();
		console.log ("[Yaniv] actionPost=", actionPost);
		
		$.post(actionPost, $(this).serialize(), null, "script");		
		
		return false;
		
	});	
	/////////////////////////////////////////////////////////////////////////
	// Mark as completed - ADP
	jQuery('.cmpl-yaniv').live('click', function(){
	 	console.log ("[Yaniv] Mark as completed clicked.");	
		
		var record = jQuery(this).parents('.act-main');
		var activityID = record.find("input").attr("activityid");
    	console.log ("[Yaniv] activityid=", activityID);
    	
		var actionPost = 'action="/completed_activity?id=' + activityID + '&method=put"' + ' accept-charset="UTF-8">';
		
		console.log ("[Yaniv] ", actionPost);
		var confirmDialogTitle = "Mark Activity as Completed";
		
		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    								'<div class="loading-popup"></div>' + 
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p><textarea rows="10" cols="10" id="summary" name="summary" placeholder="- provide a summary of the acivity to share with the team... -"/></p>' +
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 // Show overlay screen
    		 jQuery('#activity-overlay').show();
    		 jQuery('#activity-header').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '100px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');
		
		return false;
 	
	});
	/////////////////////////////////////////////////////////////////////////
	
	//Functions
	function showLess(list){
		var commentsCount = list.length - 2;
		//alert($(list).parent().prev().attr('class'));
		if($(list).parents('.list').prev().is(':not(.open)')){
			$(list).parents('.list').prev().removeClass('open').html('<a href="#">Show '+commentsCount+' more comment</a>');		
			if(list.length > 2 ){
				list.each(function(){
					$(this).addClass('invisible');
				});
				list.last().removeClass('invisible').addClass('visible');
				list.last().prev().removeClass('invisible').addClass('visible');
			}
		}
	}	
		
	function toggleNewTivits(el){
		console.log(el);
		$(el).toggleClass('open').parent().find('.tvit-list').slideToggle();
	}

	$('.new-tivits-toggle').bind('click', function(){
		toggleNewTivits(this);
	});
	
	// Sorry button clicked - Sorry Dialog needs to show up	
	$('.btn-sorry').click(function(){
		/*
		var topMarg = $(window).scrollTop() + $(window).height() / 2 - $('#sorry-tivit-window').height()/2 -100;

		openNewActivity();
		$('#sorry-tivit-window').css('top',topMarg+'px').show();
		
		*/
		var record = jQuery(this).parents('.record');
		var tivitID = record.find("input").attr("tivitid");
    	console.log ("[Yaniv] send reminder tivitID=", tivitID);

/*		
		<div class="popup" id="sorry-tivit-window">

	<form action="/">
		<h2>Sorry I can't help</h2>
		<p class="left-p"><input type="radio" name="sorry-reason" checked="checked" class="radb" id="radb-busy"/><label for="radb-busy" class="label-clear">I\'m too busy</label></p>
		<p class="left-p"><input type="radio" name="sorry-reason" class="radb" id="radb-reasign"/><label for="radb-reasign" class="label-clear">I'm reassigningthis</label></p>
		<p class="left-p reasign-row">
			<label  class="label-clear">Reassign to:</label>
			<input type="text" name="reassign-to" placeholder="Enter email address" class="reassign-to"/>
		</p>
		<p class="left-p"><textarea id="what" cols="10" rows="10" style="width:419px" class="sorry-ta"></textarea></p>

		<div class="sorry-form-btns left-p">
			<div class="form-button sorry-ok-btn" >Ok</div>
			<div class="form-button sorry-cancel-btn" id="cancel">Cancel</div>
			</div>
		</form>
	
		<div class="close" id="sorry-popup-close"></div>
	</div>

	*/	
		
		var actionPost = 'action="/decline?id=' + tivitID + '&method=put"' + ' accept-charset="UTF-8">';
		
		console.log ("[Yaniv] ", actionPost);
		var confirmDialogTitle = "Sorry I can\'t help";
		
		var confirmDialog =	'<div class="popup" id="confirmDialog">'	+
    							'<div class="loading-popup"></div>' + 
    							'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
    								'<h2>' + confirmDialogTitle + '</h2>' +
									'<p class="left-p"><input type="radio" name="sorry-reason" checked="checked" class="radb" id="radb-busy"/><label for="radb-busy" class="label-clear">I\'m too busy</label></p>' + 
									'<p class="left-p"><input type="radio" name="sorry-reason" class="radb" id="radb-reasign"/><label for="radb-reasign" class="label-clear">I\'m reassigning this</label></p>' + 
									'<p class="left-p reasign-row">' +
										'<label  class="label-clear">Reassign to:</label>' + 
										'<input type="text" name="assign_to" id="assign_to" placeholder="-- Enter email address --" class="required email" />' + 										
									'</p>' +
									'<p class="left-p"><textarea cols="10" rows="10" id="comment" name="comment" style="width:419px" class="sorry-ta" placeholder="- enter a message here if you\'d like... -"></textarea></p>' + 							
									'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
								'</form>' +
								'<div class="close" id="sorry-popup-close"></div>' +
							'</div>';		
									
									/*
									'<form id="confirmDialogForm" method="post" class="confirmPopup" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p><textarea rows="10" cols="10" id="comment" name="comment" placeholder="- enter a message here if you\'d like... -"/></p>' +
											'<div class="request"><div id="popup-cancel" class="form-button">Cancel</div><input class="form-button" type="submit" name="commit" value="OK"/></div>' +
									'</form>' +
									'<div id="popup-close" class="close"></div>' +
								'</div>';
								*/
			 
    		 jQuery('#new-activity-background').addClass('tempHide');
    		 // Show overlay screen
    		 jQuery('#activity-overlay').show();
    		
    		 jQuery(this).parents('.record').append(confirmDialog);
    		 // Center the dialog relative to where dropdown was clicked. Default for popups is 70px because of the add tivit window.
    		 $('#confirmDialog').css('top', '-70px');
    		 // by defaults, all popups are display=none which means they don't show. Let's make sure this popup shows up! 
    		 $('#confirmDialog').css('display', 'block');	
    		 
    		 // autocomplete for reassign
			 jQuery("input[id=assign_to]").autocomplete({
			  	 	source: '/ajax/invitees',
			 		 minLength: 2
			 });
			 
	    	 // Add validation in case of re-assign (we have email input)
    		 $("#confirmDialogForm").validate({
	    		 	  				           			
			 	submitHandler: function(form) {
					console.log ('[Yaniv] confirm dialog submit button clicked!');
					showLoadingAnimation('.loading-popup');
					var actionparam = $(this).attr("action") + "";
					console.log('[Yaniv] action=', actionparam);
						
					$.post($(form).attr("action"), $(form).serialize(), function() { hideLoadingAnimation ('.loading-popup');}, "script");
					
					/*	
					// Find the new status we need to change the checkbox to, it's hidden in the HTML of the confirmation popup.
					var statusobject = jQuery(form).parents('.popup'); 
					
					var newStateVal = statusobject.find("input").attr("newstate");
					if (newStateVal == "complete")	
					{
						var newState = 'record ' + statusobject.find("input").attr("newstate") + ' tivit-name-line-through';
					}
					else
					{
						var newState = 'record ' + statusobject.find("input").attr("newstate");
					}
				    //console.log ("[Yaniv] new state=", newState);
					record = jQuery(form).parents('.record');
					// Change status on UI to the new selected state (need to use this for Ajax callback)
					
					record.attr('class', newState);
						
					// Show comment of status change
					addNewComment (record);
					
					// Update respond button text
					updateRespondButtonText (record, statusobject.find("input").attr("newstate"));
					*/	
					
					$(record).slideUp(function(){
						$(this).remove();
						$('.fresh-tivits').slideDown();
						recalculateNewRequests();
					});
		
					return false;
					
					function recalculateNewRequests(){
						var newtivitQty = $('.newtivits .record').length;
				
						if(newtivitQty == 0){
							$('.newtivits').slideUp(function(){
								$(this).remove();
							});
						}else{
							$('.newtivits .qty').text(newtivitQty);
						}
					}
				
				}   	
		  
			});   		 
    		 	
	});

	$('#radb-reasign').live('change', (function() {        
		$(".reasign-row").slideDown();
		// Update the action post accordingly 
		var popupForm = jQuery(this).parents('.popup');
		var currentAction = popupForm.find("form").attr("action");
		var newAction = currentAction.replace ("/decline?", "/reassign?");
		console.log ("[Yaniv] newAction=", newAction);
		popupForm.find("form").attr("action", newAction );
				
	}));

	//$('#radb-busy').live('change', (function() {           
	//	$(".reasign-row").slideUp();
		// Update the action post accordingly 
	//	var popupForm = jQuery(this).parents('.popup');
	//	var currentAction = popupForm.find("form").attr("action");
	//	var newAction = currentAction.replace ("/reassign?", "/decline?");
	//	console.log ("[Yaniv] newAction=", newAction);
	//	popupForm.find("form").attr("action", newAction );
	//}));

	function cleanSorryPopup(){
		$('#sorry-tivit-window .reassign-to, #sorry-tivit-window .sorry-ta').val('');
		$('#sorry-tivit-window .reasign-row').hide();
		$('#radb-busy').attr('checked','checked').click();
	}
	
	
	
});

/*
	//Posting a note
	$('.post-button').live('click', function(){
		var text = $(this).parent().prev().prev().val();
		var ullist = $(this).parents('.list .list');
		var newRecords = ullist.find('.new-record');
		var newRecord = '<li class="record">' +
		'<div class="record-conteiner new-record">' +
		'<a href="#" class="delete"></a>' +
		'<div class="avatar"><img alt="Pete Campbell" src="images/avatar_2.png"></div>' +
		'<div class="text">' +
		'<p class="start">Pete Campbell started yesterday @ 5:25pm</p>' +
		'<p>'+ text +'</p>' +
		'<p><small><strong>Pete Campbell</strong>, 3 hours ago</small></p></div>' +
		'</div>' +
		'<div class="post" style="padding-left:42px;"><textarea cols="10" rows="1" style="width:420px;">Leave a note...</textarea></div><div class="clear"></div>' +
		'</li>';
		
		if(newRecords.length > 0){	
			newRecords.each(function(){
				$(this).removeClass('new-record');
			});
		}
		
		ullist.append(newRecord);
		var list = ullist.children();

		showLess(list);
		$(this).parent().parent().remove();
		$('.post textarea').autoResize({extraSpace : 0});
	});
	*/

