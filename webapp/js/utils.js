function require(url, callback) {
    var head = document.head;
    var script = document.createElement("script");
    
    script.setAttribute("src", url);
    script.setAttribute("type", "text/javascript");
    script.async = true;

    if (callback) script.addEventListener('load', callback);
    head.appendChild(script); 
}

function require_files(urls) {
    if (urls.length == 0) return;

    require(urls.shift(), function() {
        require_files(urls);
    });
}

if (!window.goog) {
    window.goog = {
        provide: function(str) {},
        require: function(str) {}
    };
}
