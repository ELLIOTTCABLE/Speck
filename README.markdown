Speck
=====
This is a super-light library that attempts to enable a “literate” form of code-testing. This
library is a part of a suite of tools intended to be used together; alongside its
[brethren](#suite), it allows for “literate” specifications that look something like this:

    Speck.new Dog do
      some_breed = Dog::Shetland
      
      Dog.new.check          { it.breed == Dog::Labrador }
      Dog.new(a_breed).check { it.breed == a_breed }
      
      Speck.new Dog.class_method :bark do
        a_dog = Dog.new
        a_dog.bark.check { |rv| rv == 'arf' }
      end
    end

Ideas, feature requests, and bugs can be reported on the [GitHub][] issue tracker:

<http://github.com/elliottcable/Speck/issues>

  [GitHub]: http://github.com/

Philosophy
----------
If you'll pay attention to the above example, you'll notice we do things a little differently around
here. The conventions that Speck is designed to enable include:

- first and foremost, we want the specification to be *source-code*, that is, we want it to read
  like any Ruby code anywhere else. Our ‘checks’ (called assertions in other environments) simply
  boil down to a `target` and a block to execute *against* that target. This is intended to be very
  idiomatic Ruby-style code.
- secondary to the former, we also like it when the checks themselves read a bit like an English
  sentence. For example, Slack ([see below](#suite)) uses the [it][] library to make the blocks look
  a little more readable in the usual case.
  - this is especially powerful, because Spark extracts the source-code responsible for each check,
    and hilights it based on the execution of that check. Thus, specification code itself is self-
    documenting output for your test suite.
- related to that, we tend to abstract the specifics of each check into variables, named in such a
  way as to express the generic form of that specific element. If we're testing that a dog takes a
  breed, but not *which* breed it takes, we place a relevant breed into `some_breed`. Similarly, we
  might put an arbitrary numeric argument into a variable named `some_number` instead of using the
  developer standards of `42` or `1337`. If, however, we were testing specific functionality related
  to handling of the magic number `2`, as opposed to `1` or `3`, then we'd write the `2` directly
  into the check-line.
- our specification sections directly include *what* they're testing, instead of a description
  thereof in a string. Whether this is an class, an instance method, or something else entirely.

Generally speaking, we try to write *code* that self-describes what it's testing, instead of writing
lots of english sentences in a DSL to redundantly describe the code being tested. (Lookin' at you,
RSpec 'n friends.)

  [it]: <http://github.com/elliottcable/it> "A sneakly library to expose iterated elements beautifully"

Suite
-----
I've intentionally designed Speck to be tiny and modular. Speck itself, here, is three extremely
brief files. To do more interesting things, and make specks easier to write, I've provided several
“sister libraries” that expand upon what Speck itself does:

- **[Slack][]**: Provides convenience methods for creating specks directly from various objects and
                 values, and various other comparators and tools to make *writing* specks easier.
- **[Spark][]**: Provides a [Rake][] task and other tools that beautifully *runs* your specks.
- **[Smock][]**: Provides a “mocking and spying” toolkit, for testing intricate code that you can't
                 easily decouple enough to test in minutae.

In no way are any of these *required* to use Speck, nor do any of them inter-depend upon eachother.
Mix-and-match as you desire. Or, y'know, write your own.

  [Slack]: <http://github.com/elliottcable/slack>
  [Spark]: <http://github.com/elliottcable/spark>
  [Smock]: <http://github.com/elliottcable/smock>
  
  [Rake]: <http://rake.rubyforge.org> "A Ruby DSL for `make`-like project tasks"

License
-------
This project is licensed very openly for your use, under a variation of the ‘MIT license.’
Details are available in [LICENSE][].
  
  [LICENSE]: <./blob/master/LICENSE.text>
