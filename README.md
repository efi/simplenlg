# SimpleNLG JRuby Gem

## Quick Overview

This is a JRuby gem which you can use to generate grammatically correct English sentences from your data via an easy to use DSL. It is based on the java library [SimpleNLG](https://code.google.com/p/simplenlg) but does not yet expose all of the library's features. "NLG" stands for "Natural Language Generation" - but you should know that already - otherwise this is probably not the right gem for you.

## SimpleNLG

This gem uses and includes [version 4.4 of SimpleNLG](https://code.google.com/p/simplenlg/downloads/list)
The author of is gem not affiliated with the SimpleNLG project (nor is he an expert of NLG technologies, DSL creation or even ruby gem cutting - which clearly shows!). The portions of the SimpleNLG original code that are included in the gem (within the lib directory) are subject to the [Mozilla Public License 1.1](http://www.mozilla.org/MPL/).

What you should know about SimpleNLG is, that it is a "Surface Realizer". Nothing more. Nothing less. It does not monkeypatch your ruby objects with a method like `to_eloquent_description`. You have lots of other domain-specific things to consider until you get there. Read more at the [SimpleNLG wiki](https://code.google.com/p/simplenlg/wiki/AppendixA).

## Installation

This gem is still in a too early development stage to be pushed to rubygems.org. I would be happy to some day promote someone else's feature-enhanced fork of this repository as the main code base for an official gem. For the moment you have to use the version provided here via github.

If you are using Bundler (which you should be) just add the following to your Gemfile:
```ruby
gem 'simplenlg', :git => 'https://github.com/efi/simplenlg.git'
```

Alternatively you can just download the code and install the gem locally or (worst of all) just copy the code into your project (while adding license compliant credits).

## Usage

The range of applications goes from simple no-brainers like
```ruby
SimpleNLG::NLG.render("mary is happy")
#=> "Mary is happy."
```
(notice the method-centric parameter syntax)

over advanced concepts like
```ruby
SimpleNLG::NLG[subject:%w[Kurt Linda], verb:"invite", object:%w[Jake Roswitha], tense:"past", negation:true]
#=> "Kurt and Linda did not invite Jake and Roswitha."
```
(notice the array accessor style)

all the way up to pretty crazy stuff like

```ruby
SimpleNLG::NLG.render{phrase(s:"Igor", v:[phrase(v:"gain",t:"past",perfect:true, o:"wisdom"),phrase(v:pre_mod("teach","now"),progressive:true)], o:"everyone")}
#=> "Igor has gained wisdom and is now teaching everyone."
```
(notice the block style)

Please find a comprehensive collection of examples in the specs. They are the only means of documentation right now.


## Status

Many basic concepts are implemented. Many more advanced topics are not covered. At the moment there is not even a list of things to be done. So many things - so little time. Consider this project to be pretty much abandoned - until noted otherwise.

## Contribute!

by

* creating GitHub issues (ideally including specs that illustrate your case)
* forking, branching, adding pull requests
* giving any other feedback

## Is it any good?
Come on... [Probably not](http://news.ycombinator.com/item?id=3067434).

## Is It "Production Ready™"?
That depends on your definition... But, no. No, it isn't.

## License
For reasons of simplicity this gem is licensed under the same license as the SimpleNLG Java library [Mozilla Public License 1.1](http://www.mozilla.org/MPL/)