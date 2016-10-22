---
layout: post
title: Simple Touch Events in CoffeeScript
description: Ipsum dolor sit amet
image: assets/images/touch.jpg
---

I am an avid fan of simple, clean and elegant CoffeeScript (and thus JavaScript of course). On top of your code being more approachable, I love the sense of accomplishment when I find a clean way to solve a problem without immediately jumping to an external library or plugin. Thus, when I was faced with the problem of handling touch events on handheld and tablet devices for our new site, I started with a blank page in my favorite editor.

Touch.coffee is a simple and straightforward CoffeeScript class written with pure JavaScript that emits touch events to your application. The only dependency this class utilizes is [EventEmitter](https://github.com/Wolfy87/EventEmitter) to aid in handling the event triggers. The full source for this class is available for browsing on [GitHub](https://gist.github.com/davidstump/5499239)

To get our class started, we will setup a few variables that will help us along the way.

    @Touch=
        horizontalSensitivity: 22
        verticalSensitivity: 6
        touchDX: 0
        touchDY: 0
        touchStartX: 0
        touchStartY: 0

The sensitivity variables allow us to specify how long a touch event should last before we go ahead and emit our event to the rest of the application. This helps us differentiate between a swipe style gesture versus a simple tap. The next two variables will help us gauge the distance travelled during our touch event. Finally, the last two will let us store the starting point of our event.

    bind: (elements...) ->
        for elem in elements
            elem.addEventListener "touchstart", (event) =>
                @handleStart(event, elem)
            elem.addEventListener "touchmove", (event) =>
                @handleMove(event, elem)
            elem.addEventListener "touchend", (event) =>
                @handleEnd(event, elem)

First we want to add a bind method to our class to attach the appropriate touch events to whichever DOM element (or elements) specified. This method handles one or more elements and attaches the touchstart, touchmove and touchend events and delegates the appropriate handler methods for each type.

    handleStart: (event, elem) ->
        if event.touches.length is 1
            @touchDX = 0
            @touchDY = 0
            @touchStartX = event.touches[0].pageX
            @touchStartY = event.touches[0].pageY

Once we have the events attached to the correct elements, we need to tell our class how to handle the various event types along the way. Here we store our initial values once the touch event is initially registered.

    handleMove: (event, elem) ->
        if event.touches.length > 1
            @cancelTouch(elem)
            return false

        @touchDX = event.touches[0].pageX - @touchStartX
        @touchDY = event.touches[0].pageY - @touchStartY

Next we need a method fired during the portion of the touch event where our finger is moving across the screen. During this event we want to detect if another touch event is registered and reset our listeners to avoid complications. We also want to update our two variables tasked with telling us the distance our touch event has travelled.

    handleEnd: (event,elem) ->
        dx = Math.abs(@touchDX)
        dy = Math.abs(@touchDY)

        if (dx > @horizontalSensitivity) and (dy < (dx * 2 / 3))
            if @touchDX > 0 then @emitSlideRight() else @emitSlideLeft()

        if (dy > @verticalSensitivity) and (dx < (dy * 2 / 3))
            if @touchDY > 0 then @emitSlideDown() else @emitSlideUp()

        @cancelTouch(event, elem)
        false

Once a touchend event is triggered and the gesture is complete, we need to gather the total distance travelled both horizontally and vertically. Once we have these values, we can use our sensitivity variables to determine if the distance of the event is great enough to warrant emitting to the rest of our application. We can also use the positive or negative value of our difference/distance variable to indicate the specific direction of our event and emit the correct notification.

    emitSlideLeft: -> @emit 'swipe:left'
    emitSlideRight: -> @emit 'swipe:right'
    emitSlideUp: -> @emit 'swipe:up'
    emitSlideDown: -> @emit 'swipe:down'

Finally, once we have successfully registered a touch event and determined that it passes our sensitivity threshold set initially, we need to emit the correct event to our application. Using [EventEmitter](https://github.com/Wolfy87/EventEmitter) we can easily send out the proper event notification with very little code.

With our new touch class, we can now bind touch events to any elements in our application.

    Touch.bind document.getElementById('menu')

Once we have our bindings set, performing actions based our touch events is as easy as calling a method when a touch event is detected.

    Touch.on 'swipe:left', => @toggleMenu()

While this class certainly doesn’t handle every possible interaction on a handheld or tablet device, it does provide you with a great base for handling basic touch events throughout your application with very little code. I welcome and look forward to any and all feedback, suggestions and improvements and hope this little class proves helpful!

Cheers!
