require 'rspec'
require 'data_mapper'
require 'dm-migrations'

require "pasty.rb"

describe "Pasty objects" do
  before(:all) do
    DataMapper.setup(:default, 'sqlite::memory:')
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  describe "are able to" do
    it "be created" do
      code = Pasty.create(
        :code   => "some simple text",
        :kind   => "dummy"
      )
      code.created_at.nil?.should be_false
      Pasty.count.should eq 1
    end 
    it "be fetched by id" do
      Pasty.get(1).id.should eq 1
    end
    it "encode html entities" do
      code = Pasty.new(
        :code   => "<html></html>",
        :kind   => "<joh"
      )
      code.code.should match(/<|>/)
      code.kind.should match(/<|>/)
      code.save.should be_true
      code.code.should_not match(/<|>/)
      code.kind.should_not match(/<|>/)
    end
    it "generate a hashkey" do
      code = Pasty.new(
        :code   => "blablab",
        :kind   => "plain"
      )
      code.hashkey.nil?.should be_true
      code.save
      code.hashkey.size.should be 4
    end
  end

  describe "do not contain previously identified bugs :" do
    it "the multiple sanitazering ..." do
      tmp = Pasty.new(
        :code => "<html>",
        :kind => "plain"
      )
      tmp.code.should eq "<html>"
      tmp.save.should be_true
      tmp.code.should eq "&lt;html&gt;"

      # it previously sanitaze at every save
      tmp.hashkey = "yoyo"
      tmp.save
      tmp.code.should eq "&lt;html&gt;"
    end
  end
end

describe "One more thing ..." do
  it "possibility to generate random string" do
    chars = ("a".."z").to_a + ("A".."Z").to_a

    str1 = Array.new(5, '').collect{chars[rand(chars.size)]}.join
    str2 = Array.new(5, '').collect{chars[rand(chars.size)]}.join
    str3 = Array.new(5, '').collect{chars[rand(chars.size)]}.join

    str1.size.should eq 5
    str2.size.should eq 5
    str3.size.should eq 5

    str1.should_not eq str2
    str2.should_not eq str3
  end
end
