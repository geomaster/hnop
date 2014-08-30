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
            title: "Missing plane could be anywhere in spacetime; Doctor who joins search", 
            website: "(wapost.com)", 
            plus_count: 322,
            comment_count: 96, 
            author: "ertob" 
        },
    ],
    secondary_headlines: [
        { 
            id: 2,
            title: "A cure for cancer in Haskell and C", 
            website: "(github.com)", 
            prefix: "Show HN:",
            prefix_url: "#/show",
            plus_count: 101,
            comment_count: 21, 
            author: "nautiluswarrior" 
        },
        { 
            id: 3,
            title: "How I became a millionare after getting kicked out of YCombinator", 
            website: "(notoriouslygood.com)", 
            plus_count: 69,
            comment_count: 6, 
            author: "shakur2pac"
        }
    ],
    columns: [
        { classname: "left", posts: [
            {
                id: 4,
                title: "On the loss of religion in me: Michael Stipe",
                website: "(stiperem.tumblr.com)",
                plus_count: 34,
                comment_count: 5,
                author: "petecapaldi"
            },
            {
                id: 5,
                title: "Snowden reveals: \"It was all a joke, I can't believe you retards fell for it LOL\"",
                website: "(nytimes.com)",
                plus_count: 22,
                comment_count: 7,
                author: "ligeon"
            },
            {
                id: 6,
                title: "What are these strange dots on my penis?",
                website: "",
                prefix: "Ask HN:",
                prefix_url: "#/ask",
                plus_count: 7,
                comment_count: 2,
                author: "syphilliswarrior"
            },
            {
                id: 7,
                title: "How I shut up the charming ones of us",
                website: "(medium.com)",
                plus_count: 40,
                comment_count: 19,
                author: "whothefuckrwe"
            },
            {
                id: 8,
                title: "Purge your soul: introduction to PFP",
                website: "(functionalftw.io)",
                plus_count: 19,
                comment_count: 0,
                author: "HaskellLordAndSavior"
            },
            {
                id: 9,
                title: "Paul Graham drops his MacBook and loses data; bans Apple from YCombinator demo days in anger",
                website: "(techcrunch.com)",
                plus_count: 20,
                comment_count: 31,
                author: "gavrillosprinciple"
            },
            {
                id: 10,
                title: "On the loss of religion in me: Michael Stipe",
                website: "(stiperem.tumblr.com)",
                plus_count: 34,
                comment_count: 5,
                author: "petecapaldi"
            },
            {
                id: 11,
                title: "Snowden reveals: \"It was all a joke, I can't believe you retards fell for it LOL\"",
                website: "(nytimes.com)",
                plus_count: 22,
                comment_count: 7,
                author: "ligeon"
            },
            {
                id: 12,
                title: "What are these strange dots on my penis?",
                website: "",
                prefix: "Ask HN:",
                prefix_url: "#/ask",
                plus_count: 7,
                comment_count: 2,
                author: "syphilliswarrior"
            }
        ]},
         { classname: "right", posts: [
             {
                id: 13,
                title: "How I shut up the charming ones of us",
                website: "(medium.com)",
                plus_count: 40,
                comment_count: 19,
                author: "whothefuckrwe"
            },
            {
                id: 14,
                title: "Purge your soul: introduction to PFP",
                website: "(functionalftw.io)",
                plus_count: 19,
                comment_count: 0,
                author: "HaskellLordAndSavior"
            },
            {
                id: 15,
                title: "Paul Graham drops his MacBook and loses data; bans Apple from YCombinator demo days in anger",
                website: "(techcrunch.com)",
                plus_count: 20,
                comment_count: 31,
                author: "gavrillosprinciple"
            },
            {
                id: 16,
                title: "On the loss of religion in me: Michael Stipe",
                website: "(stiperem.tumblr.com)",
                plus_count: 34,
                comment_count: 5,
                author: "petecapaldi"
            },
            {
                id: 17,
                title: "Snowden reveals: \"It was all a joke, I can't believe you retards fell for it LOL\"",
                website: "(nytimes.com)",
                plus_count: 22,
                comment_count: 7,
                author: "ligeon"
            },
            {
                id: 18,
                title: "What are these strange dots on my penis?",
                website: "",
                prefix: "Ask HN:",
                prefix_url: "#/ask",
                plus_count: 7,
                comment_count: 2,
                author: "syphilliswarrior"
            },
            {
                id: 19,
                title: "How I shut up the charming ones of us",
                website: "(medium.com)",
                plus_count: 40,
                comment_count: 19,
                author: "whothefuckrwe"
            },
            {
                id: 20,
                title: "Purge your soul: introduction to PFP",
                website: "(functionalftw.io)",
                plus_count: 19,
                comment_count: 0,
                author: "HaskellLordAndSavior"
            },
            {
                id: 21,
                title: "Paul Graham drops his MacBook and loses data; bans Apple from YCombinator demo days in anger",
                website: "(techcrunch.com)",
                plus_count: 20,
                comment_count: 31,
                author: "gavrillosprinciple"
            }
         ]}
    ]
};
