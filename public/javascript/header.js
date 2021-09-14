$( document ).ready(function() {

	document.title = 'Fairgreen Limited - ' + document.title;

	var content='';
	content+='<div class="container-fluid">';
		content+='<div class="navbar-header">';
				content+='<img src = "img/logo.jpg" class = "logo" alt = "Intelligent Business Solutions" >';
		content+='</div>';

		content+='<ul class="nav navbar-nav navbar-right">';
			content+='<li>';
					content+='Fairgreen Limited, 77 Faanofa Road, Kokomlemle, Accra - Ghana. ';
					content+='P.O. Box GP 579, Accra - Ghana. '; 
					content+='<b>Tel:</b> +233-302-246453/ +233-302-256920-1/024 7235190/020 6176703/026 4491885/ 057 6076881 <br>';
					content+='<b>Email:</b> promo@fairgreenlimited.com '; 
					content+='<b>Website:</b> www.fairgreenlimited.com '; 
					content+='<b>Fax:</b> +233-302 234194';
			content+='</li>'; 
		content+='</ul>';
	content+='</div>';

	content+='<hr>';


	document.getElementById("pageheader").innerHTML = content;

	//make navbar disappear when scrolling
	$(window).bind('scroll', function() {
	     if ($(window).scrollTop() > $('#pageheader').height()) {
	         $('#pageheader').fadeOut("fast");
	     }
	     else {
	         $('#pageheader').fadeIn("fast");
	     }
	});

});