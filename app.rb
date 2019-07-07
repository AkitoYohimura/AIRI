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
  user.password
  @data = user.check_login(db).flatten
    if @data.empty?
    redirect back
  else
    @title = 'user_list'
    db = user.connect_db('user.db')
    session[:user_id] = user.id
    @user = user.select_all(db)
    db.close()
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
    @title = 'add user page'
    haml :sign_up
  end
end

post '/users' do
  if params[:password] == params[:confirm_password]
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

get '/edit' do 
  if session[:user_id].nil?
    redirect '/'
  else
    user = Users.new(params)
    db = user.connect_db('user.db')
    # @detaile = user.select_detaile(db)
    haml :edit
  end
end

post '/delete' do 
  if session[:user_id].nil?
    redirect '/'
  else
    user = Users.new(params)
    db = user.connect_db('user.db')
    user.delete_user(db)
    @user = user.select_all(db)
    db.close
    erb :confirm
  end
end

post '/update' do 
  if session[:user_id].nil?
    redirect '/'
  else
    user = Users.new(params)
    db = user.connect_db('user.db')
    user.update_user(db)
    @user = user.select_all(db)
    db.close
    erb :confirm
  end
end