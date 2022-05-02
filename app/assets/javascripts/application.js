// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require pace/pace
//= require jquery_ujs
//= require jquery.contextMenu.js
//= require_tree .

$(function() {

    //Messages for loading screen
  	var random_messages = [
  	  "Whoever is patient has great understanding,... Proverbs 14:29",
  	  "Better a patient person than a warrior,... Proverbs 16:32",
  	  "Love is patient... 1 Corinthians 13:4",
      "Amazing things come to those who wait",
      "You usually have to wait for that which is worth waiting for",
      "Glorious things are waiting for you. We're just getting them ready.",
      "Enjoy the loading screen while you wait.",
      "Please be patient..."
    ];

    //Making loading screen messages random
    var loading_message = random_messages[Math.floor(Math.random() * random_messages.length)];

    var insideIframe = false;

  	//When form submits data, there must be a loading screen.
  	$('form').submit(function(){

      window.loading_screen = window.pleaseWait({
        logo: "/assets/fairgreen_logo.svg",
        backgroundColor: 'grayLighter',
        loadingHtml: "<p class='loading-message'>"+loading_message+"</p><div class='cell padding20 bg-white'><div data-role='preloader' data-type='ring' data-style='color' style='margin: auto'></div></div>"
      });

      $(window).on('beforeunload', function(){
        $(loading_screen._logoElem).css('position', 'absolute');
        $(loading_screen._logoElem).animate({
        left: 10,
        top: 11,
          width: 100,
        height: 30
        }, 400);
      });

  	});


    //for redirecting to a page containing the subform while retaining data entered into the main form
    $( "select" ).change(function() {
      if($('option:selected', this).attr('class')=="new_option"){
        saveState();
        window.location.href=this.value;
      }
    });

    //DataTable: JQuery plugin for enhancing table elements
    $('#table_id').DataTable({
      ordering:  false
    });

    //JQuery plugin for opening window in a popup view
    $(".popupwindow").popupwindow(
      {height:400,width:400,scrollbars:1,resizable:1,center:1}
    );

    //Input element's autocomplete
    $('.flexdatalist').flexdatalist({ minLength: 2 });

});


//Thanx to K K AGRAWAL( http://fellowtuts.com/jquery/resize-iframe-height-according-to-content/ )
function resizeIframe(){
  var cintval = setInterval(function(){
    if($('#dialogIframe').length){
      //var cont = $('#dialogIframe').contents().find("body").height();
      var cont = $('#dialogIframe').contents().find("html").prop('scrollHeight');
      $('#dialogIframe').css('height',cont  + "px");
      $('.dialog').css('height', (cont+20)  + "px");
      clearInterval(cintval);
    }
  },300);
}

//reloads table in an AJAX manner for controller
function AJAXRefreshTable(controller_name){

  var options = {};

  if(typeof $( "#" + controller_name + "_table_id" ).data('options') !== "undefined"){
    options = $( "#" + controller_name + "_table_id" ).data('options');
  }

  $( "#" + controller_name + "_table_id" ).DataTable().destroy();

  //wrap the table in an element
  $( "#" + controller_name + "_table_id" ).wrap("<div id='" + controller_name + "_table_wrapper'></div>");

  //load table in its raw state
  $( "#" + controller_name + "_table_wrapper" ).load( "/" + controller_name + " #" + controller_name + "_table_id" );

  //unwrap the element
  $( "#" + controller_name + "_table_id" ).unwrap();

  //reinitialise datatable() on the element with saved options
  $( "#" + controller_name + "_table_id" ).DataTable(options);
}

function openDialog(address){
  var splitAddress = address.split("/");
  var controller_name = splitAddress[1];

  $.Dialog({
      content: '<iframe id="dialogIframe" src="' + address + '" frameborder="0" style="width: 100%;" ></iframe>',
      actions: [
        {
            title: "<span class='mif-cross'></span>",
            onclick: function(el){
                $(el).data('dialog').close();
            }
        }
    ],
      options: { // dialog options
        width: '600', 
        overlay: true, 
        overlayClickClose: true, 
        overlayColor: "#1d1d1d",
        onDialogOpen: function(dialog){
          $('.dialog-overlay').css({"opacity": 0.7, "filter": "alpha(opacity=70)"});
          $('.dialog').data( "role", "draggable" ).addClass('padding20');
        },
        onDialogClose: function(dialog){
          AJAXRefreshTable(controller_name);
        }
      }
  });

  $( "#dialogIframe" ).load(function() {
    // Handler for .load() called.
    resizeIframe();
  });

}


function scanCode(results){
  $.Notify({
    caption: 'Use RFID scanner (Optional)',
    content: 'Serial number will be automatically added to the list.',
    type: 'notice',
    icon: '<span class="mif-qrcode"></span>'
  });

  // variable to ensure we wait to check the input we are receiving
  // you will see how this works further down
  var pressed = false; 
  // Variable to keep the barcode when scanned. When we scan each
  // character is a keypress and hence we push it onto the array. Later we check
  // the length and final char to ensure it is a carriage return - ascii code 13
  // this will tell us if it is a scan or just someone writing on the keyboard
  var chars = []; 
  // trigger an event on any keypress on this webpage
  $(window).keypress(function(e) {
      // check the keys pressed are numbers
      //if (e.which >= 48 && e.which <= 57) {
      // if a number is pressed we add it to the chars array
      chars.push(String.fromCharCode(e.which));
      //}
      // debug to help you understand how scanner works
      console.log(e.which + ":" + chars.join("|"));
      // Pressed is initially set to false so we enter - this variable is here to stop us setting a
      // timeout everytime a key is pressed. It is easy to see here that this timeout is set to give 
      // us 1 second before it resets everything back to normal. If the keypresses have not matched 
      // the checks in the readBarcodeScanner function below then this is not a barcode
      if (pressed == false) {
          // we set a timeout function that expires after 1 sec, once it does it clears out a list 
          // of characters 
          setTimeout(function(){
              // check we have a long length e.g. it is a barcode
              if (chars.length >= 10) {
                  // join the chars array to make a string of the barcode scanned
                  var barcode = chars.join("");
                  // debug barcode to console (e.g. for use in Firebug)
                  console.log("Barcode Scanned: " + barcode);
                  // assign value to some input (or do whatever you want)
                  //alert(barcode);

                  //results is the callback function to do whatever you want
                  results(barcode);
              }
              chars = [];
              pressed = false;
          },500);
      }
      // set press to true so we do not reenter the timeout function above
      pressed = true;
  });

  // this bit of code just ensures that if you have focus on the input which may be in a form
  // that the carriage return does not cause your form to be submitted. Some scanners submit
  // a carriage return after all the numbers have been passed.
  $(window).keypress(function(e) {
      if(e.which == 13) {
          e.preventDefault();
      }
  });
}


//Thanks to Andreas Eriksson(stackoverflow.com) but I modified it to convert table to object
function convertTabletoOject(element){
  var myTableObject = {};

  var tableHeaders = [];

  $(element).find('th').each(function(th){
    tableHeaders[th]=$(this).text().replace(/ /g,'');
  });


  //loop through each row of the table
  $("table" + element + " tbody tr").each(function(row) {
    //object of this row's cells' values
    var rowCells = {};

    //get a list of this table row's td (cells)
    var tableData = $(this).find('td');

    //For each cell, push it's value into rowCells object
    tableData.each(function(index) { rowCells[tableHeaders[index]] = $(this).text(); });

    //push this object containing list of cell values into each myTableObject's key
    myTableObject[row+1] = rowCells;
  });

  //return the object
  return myTableObject;
}


//This uses HTML5 sessions to check for existing session data and set them into their corresponding inputs
function resumeState() {
  if(typeof(Storage) !== "undefined") {
    if (sessionStorage.inputValues) {
      console.log("session storage exists");
      var formElement = JSON.parse(sessionStorage.inputValues);
      console.log(formElement);

      $.each( formElement, function( key, value ) {
        $("input[type=text], input[type=number]").each(function(index){ // With each text input, set the value to what's in the session variable
          if(key == $(this).attr('name')){
            $(this).val(value);
          }
        });

      });
      sessionStorage.clear();      
    }
  }
}

//This uses HTML5 sessions to save input element's values for later use
function saveState() {
  if(typeof(Storage) !== "undefined") {
    //an object for storing element name and values
    var formElement = new Object();

    $("input[type=text], input[type=number]").each(function(index){
      formElement[$(this).attr("name")] = $(this).val(); //add item to the formElement object
    });

    sessionStorage.inputValues = JSON.stringify(formElement); //convert object into a string because HTML storage only stores strings
    //console.log(sessionStorage.inputValues);
  } else {
    confirm("Browser does not support web storage. You'll lose data on this form when you leave this page. Proceed?");
  }
}

//This sets default folder view for MetroCSS List View.
function listView(){
    var checks = $("input:radio");
    var lv = $("#lv1");
    checks.on('change', function(){
        if ($(this).is(":checked")) {
            lv.removeClass(function (index, css) {
                return (css.match(/(^|\s)list-type-\S+/g) || []).join(' ');
            }).addClass($(this).val());
        }
    });

    checks.filter('[value=list-type-tiles]').click();
}

//load image from google search: input accepts the name of the image you want, 
//element describes what div you want to append it to
function loadImage(input, element) {
    /* ajax call to combine files*/
    $.ajax({
       type: "GET",
       data: { query: input },
       url: '/thumbnail',
       success: function(data){
          console.log('Ajax call success');
          //append data to element
          $(element).html(data);
       }
    });
}