require 'htmlentities'

class Pasty
  include DataMapper::Resource

  property :id,         Serial
  property :code,       Object, :required => true
  property :created_at, DateTime
  property :kind,       String, :required => true
  property :hashkey,    String

  before :create, :creation

  def creation(context = :default)
    self.hashkey = Pasty.generateString(4)
    self.created_at = Time.now

    encoder = HTMLEntities.new
    self.code = encoder.encode(self.code)
    self.kind = encoder.encode(self.kind)
  end

  def self.generateString(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a
    Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end
end
