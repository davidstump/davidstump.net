---
layout: post
title: Using Phoenix with Legacy Rails Applications
description: Ipsum dolor sit amet
image: assets/images/legacy-rails.jpg
---

Here's the situation: I love writing Elixir and Phoenix, but many of my clients have existing legacy Rails applications that have been running in production for years. Doing a full rewrite of all of their systems at once is time-consuming, expensive and potentially dangerous. The best-case scenario would be to gradually add or update small features on their existing application utilizing Phoenix behind the scenes. As more and more of these features get updated, the app slowly transforms from a "Rails App with a little bit of Phoenix", to a "Phoenix App with a little bit of legacy Rails". The nice part of this approach is that it is easy to experiment with and gradually make changes without introducing more bugs and degrading the overall user-experience of your client's application. This way we can add value for our client by leveraging an ecosystem with improved power and performance while avoiding disrupting the application flow that users are already familiar with.

### Setup

To get started, we need running Rails and Phoenix apps:

~~~ruby
rails new my_app ...
localhost:3000

mix phoenix.new my_new_app ...
localhost:4000
~~~

Next, we need an easy way to let our rails app proxy features to our new Phoenix app. For this, I used the gem `rails-reverse-proxy`. After bundling, I added a basic helper method to my `ApplicationController` like such:

~~~ruby
def proxy_to_phoenix
  reverse_proxy "http://localhost:4000" do |config|
    config.on_missing do |code, response|
      redirect_to root_url and return
    end
  end
end
~~~

This method will allow us to proxy an action over to our new Phoenix app, or redirect to our root path (or whatever makes sense for your use case) in the case of a missing path.

### Adding a new feature in Phoenix

Now that we have our setup complete, lets add the ability to create basic Posts in our new Phoenix app. To do that, I am going to use a generator to create a basic crud endpoint for `posts`.

~~~ruby
mix phoenix.gen.json Post posts title:string author:string body:text
~~~

As instructed by the generator, we need to add this line to our Phoenix routes

~~~ruby
resources '/posts', PostController
~~~

And finally migrate our Phoenix app up to include the new Post feature

~~~ruby
mix ecto.migrate
~~~

Great! Now we have a working Post feature that will allow us to perform basic CRUD actions on a Post model and get JSON data back. To have some usable data to demo once we get our Rails app setup to use this new Phoenix feature I am going to add a few dummy posts:

~~~ruby
changeset = Post.changeset(%Post{title: "Using Phoenix with Rails", author: "David Stump", body: "Hello, from Phoenix!"})
Repo.insert(changeset)

changeset = Post.changeset(%Post{title: "Another Blog Post", author: "David Stump", body: "I like turtles."})
Repo.insert(changeset)

changeset = Post.changeset(%Post{title: "Even moar Blog Posts", author: "David Stump", body: "Ping Pong"})
Repo.insert(changeset)
~~~

### Wiring Up Our Existing Rails Application

Now that we have our setup done and our new feature implemented in Phoenix, lets introduce it into our legacy Rails app. To do this, we are going to use the reverse proxy helper we implemented in our Setup section. We will need a controller on the Rails side to handle requests to our new Posts feature.

~~~ruby
class PostsController < ApplicationController
  include ReverseProxy::Controller
  prepend_before_action :proxy_to_phoenix

  def index
  end

  def show
  end

  ...

end
~~~

In the Rails controller above, there are two unique lines that let this handle our Phoenix feature. First we have the code `include ReverseProxy::Controller` which imports the basic actions from our reverse proxy gem. Second, we have the code `prepend_before_action :proxy_to_phoenix` which just tells each method in this controller to proxy to phoenix when a request to that action is received. Finally, our controller has all of the normal restful actions of a traditional Rails controller.

To receive requests to this controller, we are going to need to add it to our Rails routes:

~~~ruby
resources  :posts
~~~

And we are all set!

### It's Alive!

If we navigate to our various restful post paths in our Rails app, we will now see the appropriate JSON response coming from our Phoenix code through our existing Rails application. We have successfully introduced a new post feature using Phoenix and Elixir into our legacy Rails application. To an outside viewer, this feature looks just like any other output from our Rails app. As stated in our initial goals, this allows us to gradually introduce Phoenix into existing applications in a much slower and more deliberate fashion. (_click to enlarge GIF_)

[![Phoenix with Rails Demo](/assets/images/phoenix_with_rails.gif)](/assets/images/phoenix_with_rails.gif){:target="_blank"}
{: .center }

### Optional: ActiveRecord

As a followup, I thought I would demonstrate one possible approach for introducing interactions to these new Post records via Rails and ActiveRecord.  To allow both applications to connect to the same data store, I entered the same MyApp credentials into the Rails `database.yml` as well as the Phoenix `dev.exs`. Once both applications were referencing the same data, I added a generic Rails model like so:

~~~ruby
class Post < ActiveRecord::Base
end
~~~

Once that model is in place, I can fire up a Rails console and perform the following query:

~~~ruby
> Post.count
=> 3

> Post.first
=> #<Post id: 3, title: "Using Phoenix with Rails", author: "David Stump", body: "Hello, from Phoenix!", inserted_at: ..., updated_at: ...>
~~~

Awesome! Now we could interact with Phoenix created Posts from our existing Rails code should the need arise.

But wait, you say, what about having two models with full control over the posts table in the database?? Good Point! What we need to do is to tell Rails that it is only allowed to read the posts table, and is forbidden from making any changes. We want to make sure Phoenix is the owner of that table, and all Rails can do is reference the data if it needs. To do this, we are going to update the Post model we created in Rails to this:

~~~ruby
class Post < ActiveRecord::Base
  after_initialize :readonly!
end
~~~

Now, if we attempt to create Posts from the rails side, we get a stern talking to from the database:

~~~ruby
> Post.create(inserted_at: Date.today)
  (0.2ms)  BEGIN
  (0.4ms)  ROLLBACK
  ActiveRecord::ReadOnlyRecord: Post is marked as readonly
~~~

### Conclusion

The strategy outlined in this articles is far from the only one, however, it provides us with a clean way to slowly integrate new features with Phoenix into an existing Rails application. This allows us to leverage all of the power, speed, fault tolerance and concurrency of Elixir without first needing to convince a boss or client to undertake a time-consuming, expensive and potentially risky full rewrite of your application. We can now quickly add powerful, fast and concurrent features to our applications today. That's awesome :)

As always, I am more than happy to add or update sections of this article as people respond with suggestions, experiences and feedback.

Cheers!
