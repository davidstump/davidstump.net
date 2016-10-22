---
layout: post
title: How to Send Email From Your Phoenix App in Under 5 Minutes
description: Ipsum dolor sit amet
image: assets/images/phoenix-email.jpg
---

Sending scheduled or automated emails from your application is a very common problem with a number of solutions. In this write-up I am going to demonstrate one particularly easy approach to adding email functionality to your Phoenix App. [Phoenix](http://phoenixframework.org) is a web framework written in [Elixir](http://elixir-lang.org) that is enjoying a meteoric rise in popularity recently. Many people are jumping onto the Phoenix bandwagon for its explicit, non-magical and functional approach to development.

For this demonstration, we are going to use an external library that integrates [Mailgun](http://mailgun.com) into our Phoenix application. Phoenix includes the Elixir configuration file `mix.exs` which we will use to add our new dependency. We will add `{:mailgun, "~> 0.1.1"}` to the list of "deps" our project is currently using.

~~~ruby
defp deps do
  [{:phoenix, "~> 0.13"},
   {:phoenix_html, "~> 1.0"},
   {:phoenix_ecto, "~> 0.3"},
   {:postgrex, ">= 0.0.0"},
   {:phoenix_live_reload, "~> 0.4"},
   {:cowboy, "~> 1.0"},
   {:mailgun, "~> 0.1.1"}]
end
~~~

Running `mix deps.get` from our terminal will pull in all required files for including our new Mailgun library dependency.

~~~bash
$ mix deps.get
Running dependency resolution
Dependency resolution completed successfully
  mailgun: v0.1.1
* Getting mailgun (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/mailgun-0.1.1.tar)
Using locally cached package
Unpacked package tarball (/Users/david/.hex/packages/mailgun-0.1.1.tar)
~~~

Now we need to setup our Mailgun configuration in `config/config.exs`. First, however, you will need to jump over to [http://mailgun.com](http://mailgun.com) and sign up for a free sandbox account. Once you are logged in, you will want to add your first domain (under the Domains tab in the top navigation). Once created, you can click on this new domain to view the `API Base URL` and `API Key`. We will need to add both of these values to our config file. In your `config.exs` add the following information:

~~~ruby
config :my_app, mailgun_domain: "YOUR_MAILGUN_DOMAIN",
                mailgun_key: System.get_env("MAILGUN_API_KEY")
~~~

Next we need to create a Mailer module to use throughout our application. In your `lib` directory, create a new file named `mailer.ex` (not required - just my preference). Within that new file you will need to define our new Mailer module and reference our Mailgun client and configuration information.

~~~ruby
defmodule MyApp.Mailer do
  use Mailgun.Client, domain: Application.get_env(:my_app, :mailgun_domain),
                      key: Application.get_env(:my_app, :mailgun_key)

end
~~~

You will generally add a module attribute specifying the from address of your application emails within the Mailer module.

~~~ruby
@from "noreply@mydomain.com"
~~~

Finally, we add simple functions to handle the html and text versions of our application specific emails.

~~~ruby
def send_welcome_text_email(email) do
  send_email to: email,
             from: @from,
             subject: "Welcome!",
             text: "Welcome to MyApp!"
end

def send_welcome_html_email(email) do
  send_email to: email,
             from: @from,
             subject: "Welcome!",
             html: "<strong>Welcome to MyApp</strong>"
end
~~~

Once we have our email functions complete, we are ready to send emails throughout our Phoenix app.

~~~ruby
MyApp.Mailer.send_welcome_html_email(user.email)
~~~

And thats it!

## Helpful Tips:
----------

**Attachments**

Should you want or need to send attachments along with your email it is equally simple. All we need to do is add an `attachments` key to our email and provide it with a list of maps that respond to `path` and `filename`. The Mailgun library we are using handles reading the actual file so long as we give it a valid path.

~~~ruby
def send_welcome_html_email(email) do
  send_email to: email,
             from: @from,
             subject: "Welcome!",
             html: "<strong>Welcome to MyApp</strong>",
             attachments: [%{path: "priv/my_file.csv", filename: "my_file.csv"}]
end
~~~

**Templates**

You will most likely want to write your markup for an HTML email outside of the Mailer module. This is extremely easy to accomplish. You will want to update the `text` of your email to point at an external view. This would look like:

~~~ruby
html: Phoenix.View.render_to_string(MyApp.EmailView, "welcome.html", some_var: some_var),
~~~

Congratulations. You can now send emails throughout your Phoenix application. For more information please check out the following sources:

* [Mailgun Library Repo](https://github.com/chrismccord/mailgun/)
* [Phoenix Guides](http://www.phoenixframework.org/v0.14.0/docs/overview)
* [Elixir Guides](http://elixir-lang.org/getting-started/introduction.html)

Cheers!
