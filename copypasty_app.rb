require "rubygems"
require "sinatra/base"
require "data_mapper"
require "dm-migrations"

require "configure_app"
require "lib/pasty"

class ArnkCloudy < Sinatra::Base
  get '/' do
    redirect "/codes/"
  end

  get "/codes" do
   redirect "/codes/"
  end

  get '/codes/' do
    @kinds = %w{Plain Bash Java JScript Scala Ruby Diff Css Python CSharp Xml Php Cpp}
    erb :code_new
  end

  post '/codes/' do

    unless params[:code].empty? then
      redirect "/codes/" + Pasty.create(
        :code     => params[:code],
        :kind     => params[:language]
      ).hashkey
    else
      halt 401, 'Correctly fill the form'
    end
  end

  get '/codes/stats/count' do
    Pasty.count.to_s
  end

  # Try to get code by id ...
  get '/codes/:id' do
    pass unless params[:id] =~ /^\d+$/
    @pasty = Pasty.get(params[:id])
    @encoder = HTMLEntities.new

    halt 404 if @pasty.nil?
    #"<pre>#{@pasty.code}</pre>"
    erb :code_view
  end

  # Try to get code by hashkey
  get '/codes/:key' do
    pass unless params[:key] =~ /^[a-zA-Z]+$/
    @pasty = Pasty.last(:hashkey => params[:key])
    @encoder = HTMLEntities.new

    halt 404 if @pasty.nil?
    #"<pre>#{@pasty.code}</pre>"
    erb :code_view
  end

  get '/codes/:key/id' do
    pass unless params[:key] =~ /^[a-zA-Z]+$/
    pasty = Pasty.last(:hashkey => params[:key])
    pasty.id.to_s unless pasty.nil?
  end

  get '/codes/:id/hashkey' do
    pass unless params[:id] =~ /^\d+$/
    pasty = Pasty.get(params[:id])
    pasty.hashkey unless pasty.nil?
  end

  get '/codes/:key/change/:new' do
    pass unless params[:new] =~ /^[a-zA-Z]+$/

    pasty = Pasty.last(:hashkey => params[:key]) if params[:key] =~ /^[a-zA-Z]+$/
    pasty = Pasty.get(params[:key]) if params[:key] =~ /^\d+$/
    pass if pasty.nil?

    halt 401 unless pasty.update(:hashkey => params[:new])
    redirect "/codes/#{pasty.hashkey}"
  end

  get '/codes/*' do
    halt 401, 'Wrong key format ...'
  end

  run! if "arnk_cloudy_app.rb" == $0
end
