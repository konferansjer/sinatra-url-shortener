require 'sinatra/base'
require "redis"
require "sinatra/reloader"

class UrlShortener < Sinatra::Base
  register Sinatra::Reloader

  set :redis, Redis.new(url: ENV['REDIS_URL'])

  get '/' do
    erb :index
  end

  post '/shorten_url' do
    url = params[:url]
    key = SecureRandom.uuid[0..6]
    settings.redis.set(key, url)
    @link = "localhost:3000/s/#{key}"

    erb :shorten_url
  end

  get '/s/:key' do
    url = settings.redis.get(params[:key])
    redirect '/' unless url
    redirect url
  end
end
