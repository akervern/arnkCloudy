require 'rspec'
require 'data_mapper'
require 'dm-migrations'

class Dummy
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :created_at, DateTime
  property :something,  String, :length => 0..5
  property :truc,       String

  before :valid?,       :set_truc

  def set_truc(context = :default)
    self.truc = "ok"
  end
end

describe "DataMapper" do
  describe "is able to" do
    before(:all) do
      DataMapper.setup(:default, 'sqlite::memory:')

      DataMapper.finalize
      DataMapper.auto_upgrade!
    end
    it "set-him up" do
      "myDummy".should eq "myDummy"
    end
    it "create a new Dummy object" do
      date = Time.now
      var = Dummy.create(
        :title        => "Mon titre",
        :created_at   => date
      )

      var.title.should eq "Mon titre"
    end
    it "make a new Dummy object, and save it" do
      tmp = Dummy.new(
        :title        => "mon 2e titre",
        :created_at   => Time.now
      )
      tmp.save.should be_true
      tmp.title.should eq "mon 2e titre"
    end
    it "find both Dummy previously created" do
      Dummy.count.should eq 2
    end
    it "get primary key ... wow" do
      tmp = Dummy.get(1)
      tmp.title.should eq "Mon titre"
      tmp.id.should eq 1
    end
    it "validate itself" do
      tmp = Dummy.new(
        :title      => "something",
        :something  => "dsaewqrf"
      )
      tmp.save.should be_false
      tmp = Dummy.new(
        :title      => "something",
        :something  => "dsaf"
      )
      tmp.save.should be_true
    end
    it "known if it is valid" do
      tmp = Dummy.new(
        :title      => "yeah",
        :something  => ""
      )
      tmp.valid?.should be_true
      tmp.something = "12345"
      tmp.valid?.should be_true
      tmp.something = "123456"
      tmp.valid?.should be_false
    end
    it "change value automaticaly" do
      tmp = Dummy.new(
        :title  => "text",
        :truc   => "ko"
      )
      tmp.truc.should eq "ko"
      tmp.valid?.should be_true
      tmp.truc.should eq "ok"
    end
  end
  describe "after a restart" do
    before(:all) do
      DataMapper.setup(:default, 'sqlite::memory:')
      DataMapper.finalize

      # db is up to date
    end
    it "already contains Dummys" do
      Dummy.count.should eq 3
    end
  end
  describe "after migrate ..." do
    before(:all) do
      DataMapper.setup(:default, 'sqlite::memory:')

      DataMapper.finalize
      DataMapper.auto_migrate!
    end
    it "do not already contains Dummys" do
      Dummy.count.should eq 0
    end
  end
end
