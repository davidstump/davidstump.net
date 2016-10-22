---
layout: post
title: Fun with Variants and Enums in Rails 4.1
description: Ipsum dolor sit amet
image: assets/images/code.jpeg
---

The release of Rails 4.1 this past week included some [cool new features](http://weblog.rubyonrails.org/2014/4/8/Rails-4-1/) two of which are the introduction of enums and variants. Enums give us some syntatic sugar for handling attributes like status, role, etc. Variants allow us to handle separate types of templates from within a respond_to block on a given action. I setup a [tiny Rails 4.1 application](https://github.com/davidstump/enums_and_variants) to demonstrate one possible use for these two new features.

**Enum**

This application has a basic user model with a name string and an email string. The users controller contains basic index and show actions to show a list to users and their respective details. In the user model, I included an enum attribute `role` to handle differentiating between users of different types (student, admin or staff). The basic way of defining an enum attribute is as follows:

    enum role: [:student, :admin, :staff]

However, with enums used in this fashion, order must always be maintained or you risk recasting your users with a new role unintentionally. Suppose, months later, a new developer comes along and adjusts the code above like so:

    enum role: [:golfer, :student, :admin, :staff]

We have now, inadvertanly, cast every user previously assigned with the role 
`:student` to `:golfer`. Oops.

For this reason I would most likely use explicitly defined enums to avoid any potential future mishaps:

    enum role: {student: 0, admin: 1, staff: 2}

In this example, even if my new developer friend stumbles across this and updates it, they would have to explicitly overwrite the role associated with a given integer to cause any harm.

Once I have my enum defined, I now have access to all kinds of goodies to use throughout my application. I can now easily determine a given users role:

    user.role # => "student"

I can easily determine if a user is a member of a particular role:

    user.student? # => true

I can quickly assign/update a user’s role:

    user.staff! # => [sql] true

Or see all of the users scoped to a particular role:

    User.staff # => #<ActiveRecord::Relation []>

**Variants**

Variants can be used within a respond_to block to handle the same action in separate ways. Using the `User` model from above, we can render a show page unique for a particular user’s role.

    def show
        @user = User.find(params[:id])
        request.variant = @user.role.to_sym
        respond_to do |format|
            format.html do |html|
            html.student
            html.staff
            html.admin
            end
        end
    end

In this example, the variants of the show action such as `html.student` will render a view template with the name matching: `show.html+student.haml` (or erb if you prefer). This allows us to use the same logic from our show action but render different content/layouts. This pattern could also be used to present different templates for mobile devices, webviews inside native mobile apps, etc.

With very little additional code, enums and variants allowed me to add a very basic role engine to my application and render content unique to a user’s role. These are just two of the fun new updates released in Rails 4.1. Check out the [Release Notes](http://edgeguides.rubyonrails.org/4_1_release_notes.html) for some additional reading.

Cheers!
