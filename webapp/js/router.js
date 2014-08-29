goog.require('hnop.core');
goog.provide('hnop.router');

HNOP.Router.map(function() {
    this.route('top', { path: '/' });
    this.route('new');
    this.route('show');
    this.route('ask');
    this.route('posts', { path: '/posts/:post_id' });
});

HNOP.ApplicationRoute = Ember.Route.extend({
    setupController: function(controller) {

    }
});

HNOP.TopRoute = Ember.Route.extend({
    setupController: function(controller) {
        controller.set('model', frontpagesamplemodel);
    },

    renderTemplate: function() {
        this.render("frontpage");
    }
});
