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
	
	/**************************************************************************/
	/* Yaniv - Post a new  with Ajax */
	/*
	var inputCommPostButtEl = jQuery('.post-button');
	
	console.log ('[Yaniv] inputCommPostButtEl=', inputCommPostButtEl);
	
	cancelActivBtn.live('click',function(){ 
		console.log ('[Yaniv] Post comment button clicked');
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		return false;
	*/	
	/*
	jQuery("#post-comment-form").submit(function() {
		console.log ('[Yaniv] Post comment button clicked');
		
		var ullist = $(this).parents('.list .list');
		var lastPost = ullist.find ('.post');
		var newComment = '<li class="record" id="new_comment_to_add">';
		lastPost.before(newComment);
		 
		console.log ('[Yaniv] new comments record should be added by now and can accept the new comment partial to be rendered');
		
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		console.log ('[Yaniv] Ajax call came back...');
		
		return false;
	*/	
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
    $(".record").not('.tivits .record').not('.main-tivit').hover(
	   function() {
	      $(this).addClass('record-hovered');
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	   }
	);    
	
	//add from Irina Sorokina
	$('.conteiner').hover(
	   function() {
	      $(this).addClass('record-hovered');
	   },
	   function() {
	      $(this).removeClass('record-hovered');
	   }
	);

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
    /* Yaniv - changed slideUp to close */
	jQuery('.popup').slideUp('slow',function(){
		jQuery('#activity-overlay').fadeOut();
    });
    jQuery(':input','#new-activity-form')
    .not(':button, :submit, :reset, :hidden')
    .val('')
    .removeAttr('checked')
    .removeAttr('selected');
    jQuery('#new-activity-form textarea').val('');
}



// Scripts for Activity Page
// from Irina Sorokina (sorokina333@gmail.com)
jQuery(document).ready(function($){
	var description = $('.description p span').text();
	
	console.log('in Irina DOM Ready function');  
	
	//add tivit
	$('#add-tivit').click(function(){
		openNewActivity();
		$('#add-tivit-window').show();
		var myDate = new Date();
		var prettyDate =(myDate.getMonth()+1) + '/' + (myDate.getDate()+1);
		$('#due').val('tommorrow ' + '(' + prettyDate + ')');
	});	
	$('.popup .close').click(function(){
		closeNewActivity();
	});	
	$('#cancel').click(function(){
		closeNewActivity();
	});
	
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
		$(this).parents('.record').children('.show-more').fadeToggle('slow');
	});	
	$('.text-conteiner').hover(function(){
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


