---
layout: post
title: How to Use Angular and Keep Loving Rails
description: Ipsum dolor sit amet
image: assets/images/angular.jpg
---

I love writing Ruby and I love using Rails. So when I started looking for a client-side framework to help organize my front-end process and code, I was cautious of frameworks that demanded I abandon my “Rails Way” and adopt their process, style, and approach. I was looking for a framework that added value to my “Rails App”, not a solution that wanted Rails to instead act as a compliment to my client-side app.

Enter Angular stage left.

But wait, you say, tons of Angular apps use Rails (or any other framework) as a backend api for their purely client-side application. Yes, you would be very correct, however, unlike numerous other client-side frameworks, Angular allows me to easily and quickly sprinkle it on top of my traditional Rails app if that’s my preference.

**CAVEAT** - This article is only meant to demonstrate how I stayed a happy, healthy Rails developer while still enjoying all the advantages Angular provides. If, in your heart, you want nothing more than to make purely client-side apps every day, then more power to you for being focused. Thanks for reading this far - and please accept my **[token of thanks](http://f.cl.ly/items/3c340s340q3d3q3X0I0h/corgis.gif)**.

My happy-place with Angular and Rails is to let each framework do what it’s good at and then move aside. For Rails, it is well suited to handle routing, helpers and primary application logic. For Angular, it is best suited to handle client-side interactions, dynamic bindings, ajax requests and presentation logic. Using this approach I can stay away from so many headaches caused by Angular routing, Rails remote linking and endless arbitrary jQuery listeners.

Once I had settled on an approach to co-existence of Angular and Rails, my next obstacle was the somewhat verbose and obscure Angular syntax.

### CoffeeScript Sanity

Personally, I love using CoffeeScript (through that is in no way required to enjoy Angular on Rails) and my first step in incorporating Angular into my daily Rails flow was to get a handle on some of the more obtuse Angular syntax in favor of the CoffeeScript class approach.

The first step was to create a base class (NGObject) to handle basic dependency injection. This class iterates through the array of dependencies passed via the class @$inject variable and creates an instance variable with the same name. This gives us the ability to easily reference scope, services, etc passed into our angular object by friendly means (@scope, @Thing, @ThingSvc, etc). Once the dependencies are handled, the NGObject class will check for an init() function and call it if one exists.

    class @NGObject
        constructor: (dependencies...) ->
            for dependency, index in @constructor.$inject
                @[dependency.replace('$', '')] = dependencies[index]
                @init?()

Next, I use that NGObject base class to build a variety of other classes to handle specific angular object types such as NGController, NGService, etc. Each of these classes exposes a register function that wires up our object to the correct angular application. During object construction, we take the attributes of a given object (controller, service) and apply them to the proper scope. This allows us access to the attributes and functions of any object in the view layer.

    class @NGController extends @NGObject
        @register: (app) ->
            app.controller "#{@name}", this

        constructor: (@scope) ->
            @scope[key] = value for key, value of this when !@scope[key]?
            super

Specifically for service objects, we setup an NGService object that implements event notifications allowing controllers, directives, etc to register callbacks for specific service events. In the service, whenever desired, you can call the 

notify function and inform all registered observers that the specific event occurred.

    class @NGService extends @NGObject
        @register: (app) -> app.service "#{@name}", this

        observableCallbacks: {}

        on: (event_name, callback) ->
            @observableCallbacks[event_name] ?= []
            @observableCallbacks[event_name].push callback

        notify: (event_name, data = {}) ->
            angular.forEach @observableCallbacks[event_name], (callback) ->
                callback(data)

We use an event_name for each event type which adds the ability to sanely register and call multiple events explicitly as so:

    handleEvent: -> notify 'my:event'

    MyService.on 'my:event', -> doStuff()

Included in my Rails projects, this helper allow me to write concise and legible angular code in my preferred CoffeeScript class syntax. Here is a short example of a rewritten Angular controller with the new syntax and format:

    class CalendarCtrl extends @NGController
        @register window.App

        @$inject: [
            '$scope',
            'Calendar',
            'Panel',
        ]

        init: ->
            @config = @Calendar.config()

Is there anything explicitly problematic or wrong about the verbose traditional Angular syntax? Absolutely not! Does this syntax make me a happier developer and allow me to get my code out the door quicker? Without a doubt. Setting up this syntax was a fun endeavor and my hope is it makes at least one other developer’s life happier!

### Rails Resource To The Rescue

One of the last remaining hurdles to quick and easy angular development with rails is wiring up Rails resources with Angular. One source of frustration is Angular’s handling (or lack thereof) of nested resource parameters. Here are a few recent GitHub issues as examples of that frustration **[fix(ngResource): Add support for nested params](https://github.com/angular/angular.js/pull/1640)** and **[Query params not serializes as expected](https://github.com/angular/angular.js/issues/3740)**. Thankfully, Angular uses a modular approach to resource handling, so swapping ngResource with a different library is a breeze.

After months of massaging the flat params from Angular in my Rails controllers, I stumbled across **[Rails Resource](https://github.com/FineLinePrototyping/angularjs-rails-resource)**. Rails Resource is a promise based resource module that handles Angular resources exactly as a default Rails application would expect. With very little code, we can wire up Angular with our Rails resource and be on our way.

As an example, I have a basic Rails app with a model Beer that 

belongs_to a Brewery. To wire up Angular with these resources using Rails Resource I could write an Angular factory such as:

    App.factory "Beer", ['railsResourceFactory', 'railsSerializer', (railsResourceFactory, railsSerializer) ->
        resource = railsResourceFactory
            url: "/beers"
            name: "beer"
            serializer: railsSerializer ->
                @nestedAttribute 'brewery'
        ]

This code creates an Angular resource ‘Beer’ and maps it to the appropriate endpoints in our Rails application. Our next step is to setup the association with the Brewery model. You can see this done above with the following lines:

    serializer: railsSerializer ->
        @nestedAttribute 'brewery'

The serializer in Rails Resource looks to be quite powerful in allowing you to both specify relationships and alter the json coming and going to resource endpoints. The factory we have created above sets up a Beer resource in Angular that

accepts_nested_attributes_for a Brewery resource. With only the code demonstrated above, the parameters sent to the logs on a create action (for example) are just what Rails expects and is handled easily by a traditional Rails create action.

    Started POST "/beers" for 127.0.0.1
    Processing by BeersController#create as JSON
    Parameters: {"beer"=>{"name"=>"Goose Island IPA", "description"=>"Hoppy Goodness",
                "brewery_attributes"=>{"name"=>"Goose Island"}}}

### The Result

During this article I have described three tools I use to make me a happier Rails developer leveraging the power of AngularJS in my applications:

1. Letting each framework handle what it’s good at
2. The CoffeeScript helper that allows me to write more concise code in a syntax I enjoy
3. A resource module that wires up Rails resources with ease

Using these methods I setup a very basic CRUD Rails application on Github**[davidstump/beers](http://github.com/davidstump/beers)**. With the exception of the factory shown above, the only Javascript required was a short and sweet Angular controller:

    class BeersCtrl extends @NGController
        @register window.App

        @$inject: [
            '$scope',
            'Beer'
        ]

        init: ->
            @loadBeers()

        loadBeers: ->
            @Beer.query().then (results) =>
                @all = results

        create: ->
            new @Beer(@newBeer).create().then (results) =>
                @loadBeers()

        destroy: (beer_id) ->
            @Beer.$delete(@Beer.resourceUrl(beer_id)).then (results) =>
                @loadBeers()

This style of Angular fits seamlessly into my familiar mental model formed from my time developing Rails applications and ultimately makes me a quicker, happier and healthier developer.

I would love any and all feedback (and Pull Requests) on both these approaches as well as the NGHelper library itself. Thank you for taking the time to read through my thoughts and happy coding!

Cheers!
