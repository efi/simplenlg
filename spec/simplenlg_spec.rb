# -*- coding: UTF-8 -*-
require "lib/simplenlg"

describe SimpleNLG::NLG do
  
  nlg = SimpleNLG::NLG
  
  it "provide class method 'render'" do
    nlg.respond_to?(:render).should eq true
  end

  it "provide class method array accessor" do
    nlg.respond_to?(:[]).should eq true
  end

  it "not return nil when calling 'render' on nil" do
    nlg.render(nil).should_not be_nil
  end

  it "propagate exceptions in block syntax mode" do
    expect { nlg.render{0/0} }.to raise_error
  end


  it "produce simple sentences from single string input" do
    nlg.render("mary is happy").should eq "Mary is happy."
  end

  # Unicode support requires that the default JVM charset is UTF8
  # The only way to do so is to add the command line option -Dfile.encoding=UTF8
  # On Windows sytems this can be made permanent via an environmemt variable: "set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8"
  @@jvm_encoding = Java::JavaNioCharset::Charset.default_charset.name
  it "accept unicode in direct notation" do
    pending("unicode support requires UTF8 as default JVM encoding") unless @@jvm_encoding=="UTF-8"
    nlg.render("Björn has problems pronouncing the German letter ß").should eq "Björn has problems pronouncing the German letter ß."
  end 

  it "accept multibyte unicode via \\u and direct mix" do
    pending("unicode support requires UTF8 as default JVM encoding") unless @@jvm_encoding=="UTF-8"
    nlg.render("S\u00F6ren Ånstrom is not skilled enough to write the Khmer sign '៚'").should eq "S\u00F6ren Ånstrom is not skilled enough to write the Khmer sign '៚'."
  end 

  it "produce simple sentences from subject-verb-object hash input" do
    nlg.render(:subject=>"George", :verb=>"fear", :object=>"the monkey").should eq "George fears the monkey."
  end

  it "accept reasonable incomplete subject-verb-object input" do
    nlg.render(:subject=>"Nina", :verb=>"cry").should eq "Nina cries."
  end

  it "produce simple sentences from SVO hash input" do
    nlg.render(:s=>"Kate", :v=>"hate", :o=>"the donkey").should eq "Kate hates the donkey."
  end

  it "provide render functionality through the static hash accessor with new hash notation" do
    nlg[s:"Charly", v:"read", o:"a book"].should eq "Charly reads a book."
  end

  it "correctly handle particles in verb string" do
    nlg.render(:s=>"John", :v=>"pick up", :o=>"a coin").should eq "John picks up a coin."
  end 

  it "handle past tense" do
    nlg.render(:s=>"Dave", :v=>"learn", :o=>"several poems", :tense=>:past).should eq "Dave learned several poems."
  end

  it "handle future tense" do
    nlg.render(:s=>"Mike", :v=>"find", :o=>"a way", :tense=>:future).should eq "Mike will find a way."
  end

  it "handle explicit present tense" do
    nlg.render(:s=>"Oleg", :v=>"need", :o=>"a break", :tense=>:present).should eq "Oleg needs a break."
  end

  it "handle negation" do
    nlg.render(:s=>"Jennifer", :v=>"require", :o=>"more lessons", :negation=>true).should eq "Jennifer does not require more lessons."
  end

  it "handle negation as 'negated' and also in combination with altered tense" do
    nlg.render(:s=>"Dan", :v=>"catch", :o=>"the train", :negation=>true, :tense=>:past).should eq "Dan did not catch the train."
  end

  it "handle binary questions" do
    nlg.render(:s=>"Joshua", :v=>"know", :o=>"his father", :question=>:binary).should eq "Does Joshua know his father?"
  end

  it "handle binary interrogations as 'yes_no' in conjunction with altered tense" do
    nlg.render(:s=>"Dimitry", :v=>"go", :o=>"to town", :interrogation=>:yes_no, :tense=>:past).should eq "Did Dimitry go to town?"
  end

  it "handle 'who' questions (on the subject)" do
    nlg.render(:s=>"Kevin", :v=>"go", :o=>"to town", :interrogation=>:who, :tense=>:past).should eq "Who went to town?"
  end

  it "handle negated 'who' questions (with 'q' shortcut) on the object" do
    nlg.render(:s=>"Simon", :v=>"help", :o=>"Martin", :q=>:who_object, :negated=>:true).should eq "Who does Simon help?"
  end

  it "handle negated 'who' questions on the indirect object" do
    nlg.render(:s=>"James", :v=>"bring", :o=>"the wine", :q=>:who_indirect_object, :negated=>:true).should eq "Who does James bring the wine to?"
  end

  it "handle 'where' questions for the past tense" do
    nlg.render(:s=>"Susan", :v=>"walk", :interrogation=>:where, :tense=>:past).should eq "Where did Susan walk?"
  end

  it "handle 'where' questions for the past tense" do
    nlg.render(:s=>"a bird", :v=>"fly", :interrogation=>:how).should eq "How does a bird fly?"
  end

  it "handle 'what' questions" do
    nlg.render(:s=>"a fish", :v=>"swim", :q=>:what).should eq "What swims?"
  end

  it "handle minimal negated 'what' questions in future tense" do
    nlg.render(:v=>"glow", :interrogation=>:what, :negated=>true, :tense=>:future).should eq "What will not glow?"
  end

  it "handle 'what_subject' questions" do
    nlg.render(:s=>"paper", :v=>"defeat", :o=>"rock", :interrogation=>:what_subject).should eq "What defeats rock?"
  end

  it "handle onject-centic 'what' questions in future tense" do
    nlg.render(:s=>"Gertrude", :v=>"play", :o=>"golf" , :interrogation=>:what_object, :tense=>:future).should eq "What will Gertrude play?"
  end

  it "handle 'why' questions" do
    nlg.render(:s=>"the chicken", :v=>"cross", :o=>"the road", :interrogation=>:why, :tense=>:past).should eq "Why did the chicken cross the road?"
  end

  it "produce passive voice" do
   nlg.render(:s=>"Michael", :v=>"give", :o=>"the speech", :passive=>true, :tense=>:past).should eq "The speech was given by Michael."
  end

  it "be able to produce negated passive questions in future tense" do
   nlg.render(:s=>"Jonathan", :v=>"respect", :o=>"Bert", :passive=>true, :q=>:why, :tense=>:future, :negation=>true).should eq "Why will Bert not be respected by Jonathan?"
  end

  it "accept a single complement" do
    nlg.render(:s=>"Newton", :v=>"hit", :o=>"Einstein", :complement=>"with a ruler").should eq "Newton hits Einstein with a ruler."
  end

  it "accept multiple complements" do
    nlg.render(:s=>"Daniel", :v=>"take", :o=>"Olivia", :complements=>["to a party","for entertainment purposes"], :tense=>:past).should eq "Daniel took Olivia to a party for entertainment purposes."
  end

  it "accept multiple complements via 'c' shortcut and form past tense questions with them" do
    nlg.render(:s=>"Steven", :v=>"drink", :c=>["too much","too often"], :tense=>:past, :q=>:who_subject).should eq "Who drank too much too often?"
  end

  it "allow subject modifiers" do
    nlg.render(:s=>nlg.mod("Paul","holy"), :v=>"like", :o=>"chess").should eq "Holy Paul likes chess."
  end

  it "allow subject modifiers from within an ugly notation" do
    nlg.render{phrase(:s=>nlg.mod("Nepomuk","crazy"), :v=>"steal", :o=>"the money", :tense=>:past)}.should eq "Crazy Nepomuk stole the money."
  end

  it "allow subject modifiers from within an even worse notation" do
    nlg.render{phrase(:s=>SimpleNLG::NLG::Container.new(:modifier,"Nepomuk","crazy"), :v=>"steal", :o=>"the money", :tense=>:past)}.should eq "Crazy Nepomuk stole the money."
  end

  it "allow subject modifiers from within blocks" do
    nlg.render{phrase(:s=>mod("Karen","lazy"), :v=>mod("sleep","long"), :tense=>:past)}.should eq "Lazy Karen slept long."
  end

  it "allow pre and post modifiers and allow for symbols as modifier" do
    nlg.render{phrase(:s=>pre_mod("Monica","beautiful"), :v=>post_mod("go","immediately"), :o=>pre_mod("France",:to), :tense=>:past)}.should eq "Beautiful Monica went immediately to France."
  end

  it "mix modifiers and questions in past tense" do 
    nlg.render{phrase(:s=>pre_mod("Nathanael","smart"), :v=>pre_mod("search","surely"), :tense=>:past, :q=>:what_object)}.should eq "What did smart Nathanael surely search?"
  end

  it "mix modifiers and questions in present tense" do 
    nlg.render{phrase(:s=>pre_mod("Gordon","dumb"), :v=>pre_mod("assume","falsely"), :tense=>:present, :q=>:what_object)}.should eq "What does dumb Gordon falsely assume?"
  end

  # it "mix modifiers and questions in future tense" do ### TODO: Bug or (wrongly understood) feature?
  #   nlg.render{phrase(:s=>pre_mod("Nathanael","smart"), :v=>pre_mod("search","surely"), :tense=>:future, :q=>:what_object)}.should eq "What will smart Nathanael surely search?"
  # end

  it "modifiers have no influence on interrogation words" do
    nlg.render{phrase(:s=>mod("Someone","brown-eyed"), :v=>"laugh", :q=>:who)}.should eq "Who laughes?"
  end

  it "handle and-conjunctions as simple arrays in subject and object" do
    nlg.render(:s=>["Jane","Martha"], :v=>"meet", :o=>["Olga","Roswitha"]).should eq "Jane and Martha meet Olga and Roswitha." 
  end

  it "handle and-conjunctions of more than one constituent" do
    nlg.render(:s=>["Netty","Josephine","Lindsey"], :v=>"chat").should eq "Netty, Josephine and Lindsey chat."  
  end

  it "handle and-conjunctions of modified words in past tense" do
    nlg.render{phrase(:s=>[pre_mod("Lana","suspicious"),post_mod("Adam","the coward")], :v=>"disagree", :tense=>:past)}.should eq "Suspicious Lana and Adam the coward disagreed."  
  end

  it "handle explicitly declared and-conjunctions" do
    nlg.render(:s=>[:and, "Siegfried","Brunhild"], :v=>"argue").should eq "Siegfried and Brunhild argue." 
  end

  it "handle explicitly declared or-conjunctions" do
    nlg.render(:s=>[:or]<<"Titus"<<"Jorge", :v=>"win", :o=>"the match", :t=>"future").should eq "Titus or Jorge will win the match." 
  end

  #it "handle explicitly declared neither-nor-conjunctions" do
  #  nlg.render(:s=>[:neither_nor, "Sam","Max"], :v=>"understand", :o=>"anything", t:"past").should eq "Neither Sam nor Max did understand anything." 
  #end

  it "handle explicitly declared or-conjunctions in negated sentences in future tense" do
    nlg.render(:s=>["David","Jim"], :v=>"choose", :o=>[:or,"chocolate","jelly beans"], :tense=>:future, :negation=>true).should eq "David and Jim will not choose chocolate or jelly beans." 
  end

  it "provide simple conjunction syntax via hash accessor" do
    nlg[s:%w[Kurt Linda], v:"invite", o:%w[Jake Roswitha], t:"past", n:true].should eq "Kurt and Linda did not invite Jake and Roswitha." 
  end

  it "handle explicit number assignment" do
    nlg[s:"the space police", v:"arrive", nr:"plural"].should eq "The space police arrive." 
  end

  it "handle past perfect" do
    nlg[s:"Mustafa", v:"design", o:"a poster", t:"past", perfect:true].should eq "Mustafa had designed a poster." 
  end

  it "handle present perfect" do
    nlg[s:%w[Ying Yang], v:"lose", o:"balance", t:"present", perfect:true].should eq "Ying and Yang have lost balance." 
  end

  it "handle future perfect" do
    nlg[s:"curiosity", v:"kill", o:"the cat", t:"future", c:"by then", perfect:true].should eq "Curiosity will have killed the cat by then." 
  end

  it "handle basic progressive form" do
    nlg[s:"Everyone", v:"attend", progressive:true].should eq "Everyone is attending." 
  end

  it "handle conjunctions of verbs in different forms" do
    nlg.render{phrase(s:"Igor", v:[phrase(v:"gain",t:"past",perfect:true, o:"wisdom"),phrase(v:pre_mod("teach","now"),progressive:true)], o:"everyone")}.should eq "Igor has gained wisdom and is now teaching everyone." 
  end

  it "handle past progressive form" do
    nlg[s:"Denny", v:"disappoint", o:"the Greek", t:"past", progressive:true].should eq "Denny was disappointing the Greek." 
  end

  it "handle future progressive" do
    nlg[s:"Nergal", v:"have", o:"a good time", t:"future", progressive:true].should eq "Nergal will be having a good time." 
  end

  it "handle specific yes-no-questions in the progressive form" do
    nlg.render{phrase(s:"Riccardo", v:"plant", o:phrase(s:pre_mod("tree","large")), q:"yes_no", progressive:true)}.should eq "Is Riccardo planting that large tree?" 
  end

  it "handle adjectives in comparative form" do
    nlg.render{phrase(s:adj("grass","green"), comp:true, v:"grow", q:"where", progressive:true)}.should eq "Where is greener grass growing?" 
  end

  it "handle adjectives in comparative form" do
    nlg.render{phrase(s:"I", v:"face", o:phrase(o:adj("temptation","sweet"), super:true, nr:"plural"), progressive:true)}.should eq "I am facing that sweetest temptation." 
  end

end