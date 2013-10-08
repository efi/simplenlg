# -*- coding: UTF-8 -*-
require 'java'
Java::JavaLang::System.set_property "file.encoding","UTF-8"

jardir = File.expand_path("../jars", __FILE__)
Dir["#{jardir}/*.jar"].each  {|jar| require jar}
module SimpleNLG
  %w(
    simplenlg.aggregation
    simplenlg.features
    simplenlg.format.english
    simplenlg.framework
    simplenlg.lexicon
    simplenlg.morphology.english
    simplenlg.orthography.english
    simplenlg.phrasespec
    simplenlg.realiser.english
    simplenlg.syntax.english
    simplenlg.xmlrealiser
    simplenlg.xmlrealiser.wrapper
  ).each {|package| include_package package}
end
%w(
  version
  nlg
  ).each {|file| require "simplenlg/#{file}"}