---
layout: post
title: Swift Extensions
description: Ipsum dolor sit amet
image: assets/images/swift.jpg
---

This past Monday, Apple made a shocking announcement. They are moving forward
without Objective-C. After the murmuring lessened, Apple went on to demonstrate
an attractive, clean and expressive new language called Swift. Once the Taylor
Swift jokes had subsided, the developer community seemed genuinely excited about
this new look for iOS development. More information about the new language can be
found on [Apple's site](https://developer.apple.com/swift/).

Over the past year I had begun digging into iOS development and learning Objective-C.
While the thrill of seeing something you built on your iPhone was enticing, every
time I started playing with it again, I was reminded how little enjoyment I got
out of writing Objective-C. As someone not intimately familiar with the language,
Objective-C proved hard to digest, write and understand each time I hopped back
into Xcode. Sadly, without any other option for iOS apps, your only option was to
keep trudging on. Monday changed that.

During the announcement on Monday, my eyes lit up with the prospect of a clean
and easy-to-grasp language to ship applications on iOS and OSX. With that, I dove
into the [WWDC Videos](https://developer.apple.com/videos/wwdc/2014/) and full
length book [available for free on iBooks](https://itunes.apple.com/us/book/the-swift-programming-language/id881256329?mt=11)
to learn as much as I could about this new and attractive language. Coming from
Ruby, I loved what I saw: optional parenthesis, no semicolons and concise, expressive
code. To give you a sense of the improvement I saw my first steps into Swift, here
is a basic "Hello, World!" app written in both Objective-C and Swift:

*Objective-C*

~~~ ruby
  #import <Foundation/Foundation.h>

  int main(void)
  {
      NSLog(@"Hello, world!\n");
  }
~~~

*Swift*

~~~ ruby
  import Foundation

  println "Hello, World!"
~~~

Like the first time I experienced Perl after being a Java developer years ago,
I was hooked.

One of the first powerful features in Swift I started to enjoy playing with were
[Extensions](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Extensions.html).
Extensions, similar to monkey patching, allow you to add new functionality to
existing structures such as classes, structs, or enumerations. As a rubyist, my
first experiments have been focused on bringing some of the joy I get from using
ActiveSupport helpers to my iOS development space. An example of a basic extension
to add the ability to uppercase a string with `uppercase` instead of the more verbose
`uppercaseString` is as follows:

~~~ ruby
  extension String {
    var uppercase: String { return self.uppercaseString }
  }
~~~

This makes the following valid Swift syntax and instantly adds this method to
Xcode's autocomplete and syntax highlighting.

~~~ ruby
  var name = "David"
  name.uppercase # "DAVID"
~~~

To try my hand at a somewhat more technical extension I decided to add the helper
method `times` to the Int class in Swift. To do this, I needed to define a function
`times` that accepted a function as a parameter and executed it as many times as
defined by the initial Int value.

~~~ ruby
  extension Int {
    func times(task: () -> ()) {
        for _ in 0..self {
            task()
        }
    }
  }
~~~

Using this extension my Swift code begins to look very familiar...

~~~ ruby
  5.times {
    println "Hello, World!"
  }

  # Hello, World!
  # Hello, World!
  # Hello, World!
  # Hello, World!
  # Hello, World!
~~~

Finally, before admitting defeat and going to sleep, I added a few helpers
onto the Array class to bring some rubyisms to Swift.

~~~ ruby
  extension Array {
    var first: T { return self[0] }
    var second: T { return self[1] }
    var forty_two: T { return self[42] }
    var last: T { var last = self.count - 1; return self[last] }
  }
~~~

~~~ ruby
  var things = [1, 2, 3, 4, 5]
  things.first # 1
  things.second # 2
  things.last # 3
  things.forty_two # Answer to The Ultimate Question of Life, the Universe, and Everything
~~~

Cheers!
