# Hacker News Webapp

In a nutshell: a Hacker News webapp, which I aim to make an "HN on steroids". 
Overhaul of the whole design, browser desktop notifications for various events, 
fast response times because of caching, etc. Back-end and front-end; the 
back-end will probably act as a web server serving up pages to the browser and 
retrieving data via the HN API. Ideally, it will be modular, so divorcing it 
from the HN API interface and pairing it with a database server will essentially 
create an HN-like webapp from scratch. (With the obvious overhead of 
implementing server-side scripting, which is not my interest, so said 
stand-aloneness will not be a priority.)

This will also be a tech demo of my webdev skills, so I'm trying to put a lot 
of effort into it. I hope it's an investment that doesn't go to waste.

## If you're reading this...

...it's probably not of much use to you. This is my repo and is currently in a 
planning level: there's no code. So move along, nothing to see. I'm serious, 
this is all there's to it now: this Markdown file. Not a single line or code or 
design mock-up. So I'm just bullshitting here, and instead of reading this you 
are much better off watching an episode or two of a good show. My 
recommendations are *The Office (BBC, 2001)* or *Silicon Valley (HBO, 2014)*. 
If for personal use, why English then, you ask? No idea, I just started typing 
English. I find technical things easier to express in English because there is 
a word for everything.

If you're still there, oh, well, go on. You may as well drop me an email about 
how stupid the idea is, or not, I don't care. Words of encouragement are always 
nice, but consider spending them instead on something that has a better chance 
of ever becoming more than a Markdown file.

## Goals

* Modern, beautiful redesign of the Hacker News website.
* Utilization of all applicable and reasonably supported technologies if it 
will help deliver a superior experience
* The present goal is *not* a good appearance on mobile. There are great mobile 
native and web apps for HN that do this quite well. However, it might be 
introduced as a goal later
* Implemented as a browser add-on OR a separate application that will provide 
a daemon (leaning towards the latter ATM) to let users log in, upvote, 
downvote, comment, etc.
* Maybe throw in a couple of extra features, such as following stories, some 
user-based statistics (maybe more?)
* Desktop notifications using server-sent events. Notifications on replies,
upvotes or downvotes, comments on articles, comments on followed topics, etc.
* Usage of official HN (Algolia) API
* Not just to help users, but also showcase own skills. No bloating with 
completely unnecessary features, but overkill is acceptable if it illustrates 
my expertise
* Configurable **TO THE CORE**
* Sufficiently modular so it can be promoted to stand-alone HN-like web 
software (minus all the smart server-side code)

### Looks

* The frontpage can be a grid of images representing screenshots of websites 
that submissions refer to, overlaid with titles. Bigger images = more important 
posts (i.e. more upvotes).
* Besides images, a visual as well as textual representation of number of 
upvotes and comments
* Beautiful typography. Big serif (maybe even slab-serif (or maybe not)) 
titles, the rest is sans-serif
* Hmmm, maybe not a grid, but something eye-catching. Visuals are great because 
you can just skim and recognize submissions more easily
* Vector icons, zoom-friendly
* Keep the original orange color, but pick other related colors that work well 
as color chords alongside it
* Also, don't touch the YCombinator logo, obviously, apart from vectorization
* Essentially a one-page webapp, but in the sense of Facebook (with links to 
places within it and hooks into Javascript history API)
* **DISMEMBER** that fucking unreadable light gray comment color
* My mind is racing with great usability hacks about design, but let's leave it 
vague like this for now

### New features (less pertaining to design)

* Submission pages show an iframe with a website, with a heads-up display 
stemming from HN. Allow viewing and posting comments from this same page, maybe 
even allow side-by-side view (questionable utility) and directly quoting 
excerpts from the webpage in comments (very questionable feasibility)
* Allow some common tasks effortlessly, such as quoting pieces of a comment in 
a reply or auto-managing of references in comments
* Easy navigation between front page, new, Ask, Show and new Show
* Integration of some kind of bookmarklet for easy submission
* *Long-term*: Allow users to view some statistics of their contributions and 
activity, such as history of their comments, comment length, hours spent on HN, 
number of viewed stories, etc etc. A lot of fun can be done with all the 
gathered data, and as a plus: no privacy leaks, all of it is on the users' 
computers
* *Mid-longterm*: Allow users to follow other users and see when they comment 
on stuff, additionally emphasize notifications when they reply to the user
* Notifications when users' comments are replied to. Of configurable granularity
* Notifications when users' comments or submissions are upvoted/downvoted. Of 
configurable granularity, obviously (e.g. 40 new karma points)
* Notifications when followed stories or followed comment threads receive new 
replies (or even upvotes). Of configurable granularity
* Make all notifications very configurable, allow users even to write code to 
describe what kind of notifications they want---remember, HN'ers are very 
technically inclined
* Here goes more, but not now, later

## Technologies

### Front-end

* HTML5. CSS3. Javascript. Cutting-edge browser APIs such as server-sent events 
and desktop notifications
* Probably a lot of Javascript language extensions libraries because it's a 
shitty language
* Maybe a MVC Javascript library. I've never really worked with these
* jQuery will be inevitable. Or that stripped-down version of jQuery without 
ancient browser support
* A ton of other Javascript libraries for a lot of stuff
* Actually, maybe ClojureScript. It's a bold move, but I think it's a better 
language overall. Isn't it all Lispy and shit?
* Maybe not ClojureScript.
* SASS and a good grid framework (Unsemantic?), this will maybe even give it a 
decent look on mobile

### Back-end

* Things are more blurry here
* Probably a Lisp dialect. I moderately know only Common Lisp, so that's going 
to be the language of choice probably
* The parentheses make me happy and soothe my animal-like soul.
* A wrapper will probably be written in Rust. I definitely need to leave my 
C-PHP-Javascript comfort zone, but this is maybe okay to do in C too
* Also, if the statistics portion requires some heavy number-crunching, it can 
probably be done in Rust or C for performance
* I hope to god there are decent libraries for common tasks in CL, I really 
don't want to start learning Racket or Clojure now
* Continous polling of the Algolia API is the only way to do some of the stuff 
I want to...
* SQLite! Tons of SQLite. There's a great Common Lisp library for it, too

### General

* Git, ofc
* Some cool build system. SCons seems nice, so does CMake. Autotools have 
always been black magic to me, but maybe it's time to learn them, ay? I don't 
think ordinary Makefiles could cut it
* How do people handle SASS rebuilding and stuff? Via Makefiles or is that too 
cool for the new age brogrammers? (let's be PC here and add sisgrammers) Maybe 
there are genuinely better solutions though
* Something may pop up additionally, I have no idea

## Similar projects

There's a lot of Hacker News apps, but most of what I've seen are better 
realizations of the original design (and responsive, too). I'm going to Google 
"Hacker News redesign" once I leave this internetless shithole and paste the 
first couple of links here, in order to try persuade myself I'm not reinventing 
the wheel and rationalize this work.

## Landing page

I'll make a nice looking landing page with screenshots so people will see how 
sexy my webapp is. I'll offer everything for immediate download, complete with 
access to GitHub repo and precompiled binaries, so it should be just 
download-and-start. I'll try to convince people it doesn't phone home and it's 
safe to enter their usernames and passwords, but screw the skeptics, they can 
rebuild everything from source in any case.

## License

Don't know, does it really matter? Somethng open, like WTFPL. No AGPL bullshit, 
it's too restrictive to people.