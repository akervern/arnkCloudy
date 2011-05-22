require "rubygems"
require "sinatra/base"
require "lib/pasty"

class ArnkCloudy < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'

  configure :development do
    DataMapper.setup(:default, 'sqlite::memory:')
  end

  configure do
    DataMapper.finalize
    DataMapper.auto_migrate!
  end
end
