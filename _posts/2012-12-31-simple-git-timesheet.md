---
layout: post
title: A Simple Git Timesheet
description: Ipsum dolor sit amet
image: assets/images/octocat.jpg
---

At the end of each day, I find myself crawling through the git logs to record my activities for the day on our timesheet software. It eventually occurred to me that with a few super simple arguments passed to the git log command, I could have a basic output of my timesheet for that day.

Step 1\. Edit Your bash_profile file:

    $ subl ~/.bash_profile

Step 2\. Add an alias to your profile:

    git log --oneline --author="`git config --get user.name`" --since='6am'

Step 3\. Save your profile

Step 4\. Check your daily timesheet:

    david:~/Projects/octopress❮source❯$ timesheet
        2a08dac Adjust navigation mobile styles and hide search field
        816cfef Apply custom style to site
        b96240c Add Murky-Mussels Theme

Nothing complicated at all, but hopefully someone else finds this as helpful as I did. Thanks to @chris_mccord for adding the user.name snippet to this alias.

Cheers!
