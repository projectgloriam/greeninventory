(function( $ ) {
    $.fn.format_text = function( options ) {

        //default options.
        var settings = $.extend({
            // These are the defaults.
            find: ".",
            replaceWith: ".</br>",
            paragraph: 0,
            otherExceptions: []
        }, options );

    	var str = this.text();

		var myExceptionsArray = [];

		//if what the user wants to find is a full stop, then add these exceptions
		if ( settings.find == "." ){
			myExceptionsArray.push(" Mr."," Mrs.", " Dr.", ".com", " P.O.", " St.", " Ms.", " www.", ".org");
		}

		//if the array is not empty add the other array to the exception list.
		if (settings.otherExceptions.length > 0){
			myExceptionsArray = myExceptionsArray.concat(settings.otherExceptions);
		}
		
		var paragraph_count=settings.paragraph;
		var paragraph_array = [];

		//Escape special characters like full stop
		//Thanx to CoolAJ86 (http://stackoverflow.com)
		function escapeRegExp(str) {
		  return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
		}

 		//Fetch the indexes of every occurence
		//Thanx to Tim Down (http://stackoverflow.com)
		//But "while loop" is in reverse
		function getIndicesOf(searchStr, str, exceptions) {
		    var searchStrLen = searchStr.length;
		    if (searchStrLen == 0) {
		        return [];
		    }

		    var lastIndex = str.length-1;
		    var index, indices = [];
    		var exception, exceptionWordComparison, exceptionWordLength;
    		var skip = false;
			var skip_countdown=0;
			var searchStr_at_the_end = new RegExp(escapeRegExp(searchStr)+"$", "gi");
			var searchStr_at_the_start = new RegExp("^"+escapeRegExp(searchStr), "gi");
			var searchStr_at_the_middle = new RegExp("\\w*"+escapeRegExp(searchStr)+"\\w*", "gi");
			var slice_start, slice_end;
			var exception_index_position; 

	        str = str.toLowerCase();
	        searchStr = searchStr.toLowerCase();

	        //While each index (which matches the requested string) is being listed with each loop in a decrementing order, ...
		    while ((index = str.lastIndexOf(searchStr, lastIndex)) > -1) {

				//Check if the current index is part of the exceptions
				for (var i = 0; i < exceptions.length; i++) {
				    exceptionWordLength = exceptions[i].length;
				    exception = exceptions[i];

				    //Check if requested string is at the beginning, middle or at the end of the current exception string.
				    if (searchStr == exception.match(searchStr_at_the_start)){
				    	//slice from the current position of the whole text ...
				    	slice_start=index; 
				    	//...to the end of that particular string being compared to the exception.
				    	slice_end=index+exceptionWordLength;
				    } else if (searchStr == exception.match(searchStr_at_the_end)){
				    	//slice from a number of characters equivalent to the length of the exception.
				    	slice_start=index-(exceptionWordLength-1);
				    	//slice end at one character from the current index position - because slice() will exclude the index being specified at the end.
				    	slice_end=index+1;
				    } else if (exception.match(searchStr_at_the_middle) != null ){
				    	//get the index position of the the requested string in the exception and use it to calculate the slice start and end.
				    	exception_index_position=exception.indexOf(searchStr); 
				    	//slice start from the 
				    	slice_start=index-exception_index_position;
				    	//slice end should end at the numbers of characters from the current index position
				    	slice_end=index+((exceptionWordLength)-exception_index_position); //up to but not including
				    }

				    exceptionWordComparison = str.slice(slice_start, slice_end);
				    //if the extracted text is the same as the exception word, then...
				    if ( exception.toLowerCase() == exceptionWordComparison ){

				    	//skip adding the current index to the array
	    			    skip = true;
	    			    
	    			    //break out of this exception check loop.
						break;
					}
				}

				if(skip==true){

					//skip  to the index of the slice start of the extracted text
					lastIndex = slice_start-1;

					//and set skip to false so that it doesnt skip the other index
					skip=false;
				} else {
					//...else add the index to the array and set the next index to the length of the search string.
					indices.push(index);
					lastIndex = index - searchStrLen;
				}
		    }

		    return indices;
		}

		var indices = getIndicesOf(settings.find, str, myExceptionsArray);

		//if there is a paragraph...
		if(settings.paragraph>0){
			//reverse the array to read indices in ascending order...
			indices.reverse();

			//loop through each index of the array
			jQuery.each( indices, function( i, val ) {
				//decrement the paragraph_count for each loop 
				//but when paragraph_count reaches zero, add the index's value to the new paragraph array 
				//and set paragraph_count back to its default value
				if(paragraph_count==0){
					paragraph_array.push(val);
					paragraph_count=settings.paragraph;
				}

				paragraph_count=paragraph_count-1;
			});

			//reverse the new paragraph_array to read indices in descending order
			//and set indices to new paragraph_array
			indices = paragraph_array.reverse();
		}


		for (var h = 0; h < indices.length; h++) {
			//Thanx to efenacigiray's (GitHub) replaceAt() function
			str = str.substr(0, indices[h]) + settings.replaceWith + str.substr(indices[h] + 1);
		}
        
        return this.html(str);
    };
 
}( jQuery ));