//---------------------------------------------------------
//	▼ UA ▼
//---------------------------------------------------------
var UA;
(function(){
	
		UA = {
		//---------------------------------------------------------
		//	constant
		//---------------------------------------------------------
		MOBILE	: "mobile",
		PC			: "pc",
		TABLET	: "tablet",
	
		CHROME	: "chrome",
		SAFARI	: "safari",
		FIREFOX	: "firefox",
		IE			: "ie",
		OPERA		: "opera",
		DS3			: "ds3",
		NEWDS3	: "newds3",
		WIIU		: "wiiu",
		IPHONE	: "iphone",
		IPAD		: "ipad",
		ANDROID : "android",
	
		//---------------------------------------------------------
		//	variable
		//---------------------------------------------------------
		type			: null,
		career		: null,
		version		: null,
		osversion	: null
	};
	
	//---------------------------------------------------------
	//	initialize
	//---------------------------------------------------------
	function init() {
	
		var ua = window.navigator.userAgent.toLowerCase();
		UA.type = UA.PC;
		UA.career = UA.CHROME;
		
		
		// Nintendo
		if ( ua.indexOf( '3ds' ) != -1 ) {
			if ( ua.indexOf( 'iphone' ) != -1 ) UA.career = UA.NEWDS3;
			else UA.career = UA.DS3;
			UA.type = UA.MOBILE;
		} else if ( ua.indexOf( 'wiiu' ) != -1 ) {
			UA.career = UA.WIIU;
		}
		
		// Internet Explorer
		else if ( ua.indexOf('msie') != -1 || ua.indexOf('trident') != -1 ) {
			UA.career = UA.IE;
	    var array = /(msie|rv:?)\s?([\d\.]+)/.exec(ua);
	    UA.version = (array) ? parseInt( array[2] ) : null;
		}
		
		// iOS
		else if ( ua.indexOf( 'ipad' ) != -1 ) {
			UA.career = UA.IPAD;
			UA.type = UA.TABLET;
			var array = /\/([0-9\.]+)(\smobile\/[a-z0-9]{6})?\ssafari/.exec(ua);
	    UA.version = (array) ? parseInt( array[1] ) : null;
	    ua.match(/CPU OS (\w+){1,3}/g);
	    UA.osversion = (RegExp.$1.replace(/_/g, '')+'00').slice(0,3);
		}
		else if ( ua.indexOf( 'iphone' ) != -1 || ua.indexOf( 'ipod' ) != -1 && ua.indexOf( '3ds' ) == -1 ) {
			if ( screen.width == 320 && screen.height == 240 ) {
				UA.career = UA.NEWDS3;
				UA.type = UA.MOBILE;
			} else {
				UA.career = UA.IPHONE;
				UA.type = UA.MOBILE;
				var array = /\/([0-9\.]+)(\smobile\/[a-z0-9]{6})?\ssafari/.exec(ua);
		    UA.version = (array) ? parseInt( array[1] ) : null;
				ua.match(/iPhone OS (\w+){1,3}/g);
	    	UA.osversion = (RegExp.$1.replace(/_/g, '')+'00').slice(0,3);
			}
		}
		
		// Android
		else if( ua.indexOf( 'android' ) != -1 ) {
			UA.career = UA.ANDROID;
			if ( ua.indexOf( 'mobile' ) != -1 ) UA.type = UA.MOBILE;
			else UA.type = UA.TABLET;
		}
		
		// Chrome
		else if( ua.indexOf( 'chrome' ) != -1 ) {
			UA.career = UA.CHROME;
			var array = /chrome\/([0-9\.]+)/.exec(ua);
	    UA.version = (array) ? parseInt( array[1] ) : null;
		}
		
		// Safari
		else if( ua.indexOf( 'safari' ) != -1 ) {
			UA.career = UA.SAFARI;
			var array = /version\/([\d\.]+)/.exec(ua);
	    UA.version = (array) ? parseInt( array[1] ) : null;
		}
		
		// Firefox
		else if( ua.indexOf( 'gecko' ) != -1 && ua.indexOf( '3ds' ) == -1 ) {
			UA.career = UA.FIREFOX;
			var array = /firefox\/([0-9\.]+)/.exec(ua);
	    UA.version = (array) ? parseInt( array[1] ) : null;
		}
		
		// Opera
		else if( ua.indexOf( 'opera' ) != -1 ) {
			UA.career = UA.OPERA;
			var array = /(^opera|opr).*\/([0-9\.]+)/.exec(ua);
	    UA.version = (array) ? parseInt( array[2] ) : null;
		}
	}
	

	init();
})();

//---------------------------------------------------------
//	▲ UA ▲
//---------------------------------------------------------
