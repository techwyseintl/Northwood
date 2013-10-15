// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Check if we're in IE 6
var agt				= navigator.userAgent.toLowerCase();
var is_ie     = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
var is_ie6    = (is_ie && agt.indexOf("msie 6.")!=-1 );    


// Activate background image caching on IE6 to prevent image flicker
if (is_ie6) {
	document.execCommand('BackgroundImageCache', false, true);
}

function generate_webpage_address(first_name, last_name) {
	var names =  (first_name+' '+last_name).toLowerCase().split(' ');

	if(names.length>1 && names[1] !='') {
		return names[0]+'-'+names[1];
	} else {
		return names[0];
	}
}


function set_applicant_how_did_you_hear_about_us_text_visibility(){
  if($('pre_approval_notes_applicant_how_did_you_hear_about_us').value == 'Other'){    
   $('applicant_how_did_you_hear_about_us_text_label').show();
   $('applicant_how_did_you_hear_about_us_text').show();    
  }else{
   $('applicant_how_did_you_hear_about_us_text_label').hide();
   $('applicant_how_did_you_hear_about_us_text').hide();     
  }
}