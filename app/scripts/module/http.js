(function(exports) {
	var httpRequest;

	function Deffer (){
	}
	Deffer.prototype.success = function(fn){
		this.success = fn;
		return this;
	};

	Deffer.prototype.fail = function(fn){
		this.fail = fn;
		return this;
	};

	function ready(http) {
		if (httpRequest.readyState === 4) {
			if (httpRequest.status === 200) {
				http.success(httpRequest);
			} else {
				http.fail(httpRequest);
			}
		}
	}

	function http(url) {
		var def = new Deffer();
		if (exports.XMLHttpRequest) { // Mozilla, Safari, ...
			httpRequest = new XMLHttpRequest();
		} else if (window.ActiveXObject) { // IE
			try {
				httpRequest = new exports.ActiveXObject('Msxml2.XMLHTTP');
			} 
			catch (e) {
				try {
					httpRequest = new exports.ActiveXObject('Microsoft.XMLHTTP');
				} 
				catch (e) {}
			}
		}

		if (!httpRequest) {
			return false;
		}
		httpRequest.onreadystatechange = function(){ ready(def); };
		httpRequest.open('GET', url);
		httpRequest.send();

		return def;
	}

	exports.http = http;

})(window);
