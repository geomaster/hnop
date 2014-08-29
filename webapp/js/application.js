goog.require('hnop.router');
goog.provide('hnop.app');

HNOP.ApplicationController = Ember.Controller.extend({
    
    appTitle: "Hacker News",
    navbar: [
        { name: "navlink-top", url: "#", title: "Top" },
        { name: "navlink-new", url: "#", title: "New" },
        { name: "navlink-ask", url: "#", title: "Ask HN" },
        { name: "navlink-show", url: "#", title: "Show HN" }
    ],
    notificationCount: 3,
    karma: 540,
    username: "thegeomaster"
});

HNOP.TopController = Ember.ObjectController;

var frontpagesamplemodel = {
    primary_headlines: [
        { 
            id: 1,
            title: "aaaabmabdmnadbmadb", 
            website: "sdsjkdfhkj", 
            plus_count: 34,
            comment_count: 12, 
            author: "sdkfjsdk" 
        },
    ],
    secondary_headlines: [
        { 
            id: 2,
            title: "aaaabmabdmnadbmadb", 
            website: "sdsjkdfhkj", 
            plus_count: 34,
            comment_count: 12, 
            author: "sdkfjsdk" 
        },
        { 
            id: 3,
            title: "aaaabmabdmnadbmadb", 
            website: "sdsjkdfhkj", 
            plus_count: 34,
            comment_count: 12, 
            author: "sdkfjsdk" 
        },
    ],
    columns: [
        { classname: "left", posts: [] },
        { classname: "right", posts: [] },
    ]
};
