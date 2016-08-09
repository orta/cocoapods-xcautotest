# cocoapods-xcautotest

_note_ - this is a README driven project, this is where I want it to be. A lot of the infrastructure is in place.

**OK, so, here's the problem.**

You write tests, because you want to ensure a baseline quality. Good on 'ya. You write a lot of tests over time.

Eventually this becomes it's own problem. Tests take time to compile, they start to really rack up the minutes to run.

So you think, OK, I can work around this. You use [Xcode Schemes to run only a few tests](http://artsy.github.io/blog/2016/04/06/Testing-Schemes/) each time. It's a bit of work, but you can deal with it.

Then you do [some work in another language](http://danger.systems/guides/creating_your_first_plugin.html#tests) - with real TDD. You end up being pretty frustrated at waiting tens of seconds for your sim to be running your tests. This isn't how it should be.

---

XCAutoTest is a CocoaPods plugin. It is both a server that runs inside your terminal, and a library that runs inside your project.

### Terminal

The job of this part of the system is to listen for file system changes from your tests. When a file is saved, it will compile those tests into a bundle, then pass that over to the app to run as a testcase.

### Library

The library's job is to see if the server is running at the end of an XCTest run. If the server is running, then it will stop the suite from closing, and listen for new test bundles. This will trigger a test-run for just the compiled tests.

## Installation

    $ gem install cocoapods-xcautotest

## Usage

I'm still thinking a bit about how this can be done independent of your entire team. For now, I will be using the CocoaPods plugin infrastructure. If this is a blocker, I'm interested in ways to improve it.

Add the gem to your `Gemfile`, and add `plugin 'cocoapods-xcautotest'` to your `Podfile`.

Start up the server:

    $ bundle exec pod xcautotest


## Hacking on the project

To understand the principals of this project - you should be familiar with how [Injection for Xcode works](http://artsy.github.io/blog/2016/06/29/code-spelunking-injection/). If you want the history on the project, look at [this issue](https://github.com/artsy/mobile/issues/26).

Then it'd be a good idea to have a brief look over the [VISION.md](VISION.md) to grok the overall plan.

To get started, clone the repo, install the deps, and run the tests.

```ruby
git clone https://github.com/orta/cocoapods-xcautotest.git
cd cocoapods-xcautotest
bundle
bundle exec rake
```

This gets you fully set up, however, you're going to want to have this working inside an iOS project to true make changes. So you'll need to use [a Gemfile](https://guides.cocoapods.org/using/a-gemfile.html) on that project. Your Gemfile should look somewhat like:

``` ruby
gem "cocoapods", "~> 1.0"
gem "cocoapods-xcautotest", path: "/path/to/where/this/is/cloned"
```

Then include the plugin reference in your `Podfile`:

``` ruby
plugin "cocoapods-xcautotest"
```

Then whenever you `bundle exec pod install` it will use your development version of xcautotest. 
