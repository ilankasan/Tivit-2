jQuery.noConflict();

/* Yaniv's stuff */
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
/*
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
  	console.log ('[Yaniv] in submitWithAjax function');
    jQuery.post(this.action, jQuery(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery(document).ready(function() {
  console.log('in Ajax DOM Ready function');  
  jQuery("#create-new-tivit-form").submitWithAjax();
})

*/

jQuery(document).ready(function($){

	console.log ('[Yaniv] in Artem DOM ready function');
	
	/**************************************************************************/
	/* Yaniv - Create new tivit with Ajax */
	jQuery("#create-new-tivit-form").submit(function() {
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		return false;
	});
	/**************************************************************************/
	
	//$('.post-button').live('click', function(){
	jQuery('.new_tivitcomment').live ('submit', function() {
		
		console.log ('[Yaniv] Post comment button clicked');
		
		var actionparam = $(this).attr("action") + "";
		console.log('[Yaniv] action=', actionparam); 

		//var mystring = "hello/world/test/world";
		var find = "/";
		var regex = new RegExp(find, "g");
		var newcommentId = actionparam.replace(regex, "");
		//document.write (mystring.replace(regex, "****"))
		
		console.log('[Yaniv] newcommentId=', newcommentId); 
		
		//var newCommentId = "new_comment_to_add";
		
		var ullist = $(this).parents('.list .list');
		var lastPost = ullist.find ('.post');
		//var newComment = '<li class="record" id="new_comment_to_add"></li>';
		
		// This is critical for making sure the Ajax call will insert the div in the right place. See create.js.erb in tivitcomments viewer folder (JS view)
		var newComment = '<li class="record" id="' + newcommentId + '"></li>';
		
		console.log ('[Yaniv] newComment=', newComment);
		
		lastPost.before(newComment);
		 
		console.log ('[Yaniv] new comments record should be added by now and can accept the new comment partial to be rendered');
		
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		
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
	$('.conteiner').live('mouseover mouseout', function(event) {
	  if (event.type == 'mouseover') {
	    // do something on mouseover
	    $(this).addClass('record-hovered');
	    $(this).children('.edit-menu').children('.icon').toggle();
	  } else {
	    // do something on mouseout
	    $(this).removeClass('record-hovered');
	    $(this).children('.edit-menu').children('.icon').toggle();
	    $(this).children('.menu-dialog').toggle();
	  }
	});
	
	
    /*jQuery(document).click(function(){
         console.log('click');
        jQuery('.status-list-dialog').remove();
     });*/
	
	/***********************************************************************************************/
	// tivit status checkbox
    var statusIcon = jQuery('.status .icon');
    var statusList = '<div class="status-list-dialog">'+
                        '<ul class="status-list">'+
                            '<li class="unread"><div class="ico"></div>Not started</li>'+
                            '<li class="inprog"><div class="ico"></div>I\'m on it</li>'+
                            '<li class="complete"><div class="ico"></div>I\'m done!</li>'+
                            '<li class="busy"><div class="ico"></div>I\'m too busy</li>'+
                            '<li class="attention"><div class="ico"></div>Propose new time</li>'+
                        '</ul>'+
                     '</div>';
                     
     statusIcon.live('click',function(){
     	
     	//var tivitobject = jQuery(this).parent();
     	//console.log ("[Yaniv] tivitobject=", tivitobject);
     	
     	// Check if the user owns this tivit or not. If not, don't allow to change status therefor dropdown will not open
		var mytivit = jQuery(this).parent().find("input").attr("mytivit");
    	console.log ("[Yaniv] status mytivit=", mytivit);
    	
     	if (mytivit == "no")
     		return;
     	
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
	/***********************************************************************************************/

     $('body').click(function(event) {

         if (!jQuery(event.target).closest('.status-list-dialog').length && jQuery('.status-list-dialog').is(':visible')) {
             jQuery('.status-list-dialog').remove();
         }else if(!jQuery(event.target).closest('#user-nav').length && jQuery('#sm_1').is(':visible')){
        	 jQuery('#sm_1').hide();
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
    	var dueDate = "";
    	//console.log(newState=='complete');
    	//if(newState=='inprog' || newState=='complete'){
    		switch(newState){
	    		case 'inprog':
	    			console.log('[Yaniv] tivit status change - ON IT -');
	    			var confirmDialogTitle = 'I\'m on it!';
	    			//var confirmDialogText = 'Want to add a comment or attach file?';
	    			var actionPost = 'action="/onit?id=' + tivitID + '&method=post" accept-charset="UTF-8">';
	    			break;
	    		case 'complete':
	    			console.log('[Yaniv] tivit status change - COMPLETE -');
	    			var confirmDialogTitle = 'I\'m Done!';
	    			var actionPost = 'action="/done?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			break;
	    		case 'busy':
	    			console.log('[Yaniv] tivit status change - BUSY/CANNOT DO IT -');
	    			var confirmDialogTitle = 'Sorry, cannot do it now';
	    			var actionPost = 'action="/decline?id=' + tivitID + '&method=put" accept-charset="UTF-8">';
	    			break;
	    		case 'attention':
	    			console.log('[Yaniv] tivit status change - ATTENTION -');
	    			var confirmDialogTitle = 'Propose Another Date';
	    			var actionPost = 'action="/proposedate?id=' + tivitID + '&method=post" accept-charset="UTF-8">';
	    			dueDate = '<p class="input-date"><label for="propose_date">How about:</label>' +
									'<input id="propose_date" name="propose_date" type="text" autocomplete="off" placeholder="choose date"/>' + 
								    '<img src="/images/cal.gif" onclick="javascript:NewCssCal(\'propose_date\', \'mmddyyyy\', \'arrow\')" class="ico_calc"/>' +
							  '</p>';
								           
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
									'<form id="confirmDialogForm" class="confirmPopup" method="post" ' + actionPost +
											'<h1>' + confirmDialogTitle + '</h1>' +
											'<p><textarea rows="10" cols="10" id="comment" name="comment"/></p>' +
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
    		 //////////////////////////////////////////////////////////
    		 // Change status on UI to the new selected state (need to use this for Ajax callback)
    		 //record.attr('class',newClassValue);
    		 //////////////////////////////////////////////////////////
    	 //}
    	 //else
    	// {
    	//	 jQuery('.status-list-dialog').remove();
    	//	 record.attr('class',newClassValue);
    	// }

		/************************************************************/
		// close popup that is currently opened */
		$('.popup .close').click(function(){
			console.log ('[Yaniv] NEW popup close button clicked')
			hidePopup();
			
		});	
		
		$('#popup-cancel').click(function(){
			console.log ('[Yaniv] popup cancel clicked')
			hidePopup();
		});
			
		});
    	/************************************************************/
    
     jQuery("#confirmDialogForm").submit(function() {
		console.log ('[Yaniv] confirm dialog submit button clicked!');
		var actionparam = $(this).attr("action") + "";
		console.log('[Yaniv] action=', actionparam);
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		console.log ('[Yaniv] Ajax call came back...');
		return false;
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
/* Not in use */
function removePopup(){
	console.log ('[Yaniv] Closing popup');
	jQuery('.popup').remove();
	jQuery('#activity-overlay').fadeOut();
}
function hidePopup(){
	console.log ('[Yaniv] Hiding Popup');
	// Confirmation dialog div HAS to be removed form the page, but popup should be hidden since I'm using it for add tivit which is on the view/server side
	jQuery('#confirmDialog').remove();
	jQuery('.popup').hide();
	jQuery('#activity-overlay').fadeOut();
}
			
function closeNewActivity(){
    var layer = jQuery('#new-activity-complete');
    if(jQuery('#calBorder').is(':visible')){
        closewin("due"); stopSpin();
    }
    jQuery(layer).slideUp('slow',function(){
		jQuery('#activity-overlay').fadeOut();
    });    
    /* Yaniv - changed slideUp to close */
	/*
	jQuery('.popup').slideUp('slow',function(){
		jQuery('#activity-overlay').fadeOut();
    });
    */
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
	// close popup that is currently opened */
	$('.popup .close').click(function(){
		console.log ('[Yaniv] NEW popup close button clicked')
		hidePopup();
	});	
	$('#cancel').click(function(){
		console.log ('[Yaniv] popup cancel clicked')
		hidePopup();
	});
	//function closePopup(){
	//	$('.popup').hide();
	//	$('#activity-overlay').fadeOut();
	//}
	/************************************************************/
	//assign myself
	$('.popup .assign').click(function(){
		if($(this).is('.active')){
			$(this).removeClass('active');
			$('#who').val('').removeAttr('disabled');
		} else {
			$(this).addClass('active');
			$('#who').val('don.drapper@sterlingcooper.com').attr('disabled','disabled');
		}
	});
	
	/* Yaniv - Show/Hide comments when clicking on a tivit */
	$('.text-conteiner').live('click', function(){
		//alert($(this).parents('.record').children('ul').attr('class'));
		console.log('[Yaniv] tivit clicked - show/hide comments...');
		$(this).parents('.record').children('ul').fadeToggle('slow');
		//$(this).parents('.record').children('.show-more').fadeToggle('slow');
		$(this).parents('.record').children('.respond').fadeToggle('slow');
	});	
	$('.text-conteiner').hover(function(){
		$(this).css('cursor','pointer');
	});
	$('.text-conteiner').live('mouseover mouseout', function(event) {
	  if (event.type == 'mouseover') {
	    // do something on mouseover
	    $(this).css('cursor','pointer');
	  } else {
	    // do something on mouseout
	  }
	});
	
	
	/* Clicking comments icon opens comments */
	$('.comments').live('click', function(){
		//alert($(this).parents('.record').children('ul').attr('class'));
		console.log('[Yaniv] tivit clicked - show/hide comments...');
		$(this).parents('.record').children('ul').fadeToggle('slow');
		$(this).parents('.record').children('.show-more').fadeToggle('slow');
		$(this).parents('.record').children('.respond').fadeToggle('slow');
		
	});	
	$('.comments').hover(function(){
		$(this).css('cursor','pointer');
	});
	
	//change respond status
	$('.respond .form-button').live('click', function(){
	
		var respondList = 	'<div class="status-list-dialog menu-dialog">' +
							'<ul class="status-list">' +
								'<li class="inprog"><div class="ico"></div>I\'m on it</li>' +
								'<li class="complete"><div class="ico"></div>I\'m finished</li>' +
								'<li class="busy"><div class="ico"></div>I\'m too busy</li>' +
								'<li class="attention"><div class="ico"></div>Propose new time</li>' +
							'</ul>' +
						'</div>';

		$(this).parent().append(respondList);
		$(this).next().addClass('visible');
	});
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
	
	//Leave a note
	$('.post textarea').live('click', function(){
		if($(this).parent().is('.post-style')){
			return false
		}else{
			$(this).val('');
			$(this).parent().addClass('post-style')
			.append('<p><input type="submit" value="Post" class="post-button"><a href="#" class="attach-file">attach a file</a></p>');
		}
	});
	//Or don't do anything BUG
	$('.post-style').live('mouseleave', function(){
		//$(this).removeClass('post-style').html('<textarea cols="10" rows="1">Leave a note...</textarea>');
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
	
	
	//delete comment
	$('.delete').live('click', function(){
		var record = $(this).parent();
		record.slideUp('slow');
		setTimeout(function(){record.remove();},3000);
		return false;
	});
	
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
});


