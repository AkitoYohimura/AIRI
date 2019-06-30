require 'sinatra'
require 'sinatra/reloader'
require 'logger' 
require 'haml' 
$:.unshift File.dirname(__FILE__)  
require_relative 'models/users.rb'

$log = Logger.new('log/app.log', 3, 1024 **2 )

enable :sessions

get '/' do
  @title = 'login page'
  erb :index
end

post '/confirm' do
  @title = 'all user list'
  user = Users.new(params)
  redirect back if user.id.nil? | user.password.nil?
  db = user.connect_db('user.db')
  @data = user.check_login(db).flatten
  if @data.empty?
    redirect back
  else
    @title = 'user_list'
    session[:user_id] = user.id
    @all_user = select_all(database)
    erb :confirm
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/sign_up' do
  if session[:user_id].nil?
    redirect '/'
  else
    haml :sign_up
  end
end

post '/users' do
  if params[:password] == params[:confirm_password]
    user = Users.new(params[:id], params[:name_jap], params[:name_eng], params[:password], params[:email], 0)
    user = Users.new(params)

    db = user.connect_db('user.db')
    user.insert_user(db)
    @user = user.select_all(db)
    db.close
    erb :confirm
  else
    redirect back
  end
end