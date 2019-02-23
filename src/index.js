'use strict';

// Require index.html so it gets copied to dist
// require('asciidoctor.js');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var bookmarksItem = 'accu2018_bookmarks';

var bookmarks = localStorage.getItem(bookmarksItem);
if (bookmarks) {
    bookmarks = JSON.parse(bookmarks);
}
else {
    bookmarks = [];
}

var flags = {
    bookmarks: bookmarks,
    apiBaseUrl: process.env.API_BASE_URL
};

setTimeout(function() {
    var app = Elm.ACCUSchedule.embed(mountNode, flags);

    // handle "store" port to save bookmarks proposals
    app.ports.store.subscribe(function(bookmarks) {
        localStorage.setItem(bookmarksItem, JSON.stringify(bookmarks));
    });
});
