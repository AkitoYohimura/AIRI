require 'sinatra'
require 'sinatra/reloader'
require 'redcarpet'
require 'sqlite3'

enable :sessions

def connect_db(db)
  database = SQLite3::Database.new("db/#{db}")
end

def check_login(database, usr_id, usr_pass)
  sql = "SELECT * FROM reg_users WHERE usr_id=#{usr_id} AND usr_pass='#{usr_pass}'"
  # database.execute(sql,@usr_id, @usr_pass)
  database.execute(sql)
end

def insert_user(database, reg_id, reg_name)
  # sql = "INSERT users from users WHRER "
end

def select_all(database)
  sql = "SELECT * FROM all_users"
  database.execute(sql)
end

get '/' do
  @title = 'login_page'
  erb :index
end

post '/confirm' do
  @usr_id = params[:usr_id]
  @usr_pass = params[:usr_pass]
  redirect back if @usr_id.empty? | @usr_pass.empty?
  database = connect_db('test_db.db')
  @data = check_login(database, @usr_id, @usr_pass).flatten
  if @data.empty?
    redirect back
  else
    @title = 'user_list'
    session[:usr_id] = @usr_id
    @all_usr = select_all(database)
    erb :confirm
  end
end

get '/logout' do
  session.clear
  redirect '/'
end
