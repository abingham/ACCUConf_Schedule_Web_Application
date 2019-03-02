'use strict';

var asciidoctor = require('asciidoctor.js')();

const { Elm } = require('./Main');

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
    apiBaseUrl: process.env.API_BASE_URL,
    width: window.innerWidth,
    height: window.innerHeight
};

setTimeout(function () {
    var app = Elm.ACCUSchedule.init({
        flags: flags,
    });

    // handle "store" port to save bookmarks proposals
    app.ports.store.subscribe(bookmarks => {
        localStorage.setItem(bookmarksItem, JSON.stringify(bookmarks));
    })
});

class RenderAsciidoc extends HTMLElement {
    connectedCallback() {
        let shadowRoot = this.attachShadow({mode: 'open'}); 
        let text = this.childNodes[0].data;
        let html = asciidoctor.convert(text);
        shadowRoot.innerHTML = html;
    }
}
  
window.customElements.define('render-asciidoc', RenderAsciidoc);