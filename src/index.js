'use strict';

// require('asciidoctor.js');

const {Elm} = require('./Main');

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
    var app = Elm.ACCUSchedule.init({flags: flags});

    // handle "store" port to save bookmarks proposals
    app.ports.store.subscribe(bookmarks => {
        localStorage.setItem(bookmarksItem, JSON.stringify(bookmarks));
    })
});
