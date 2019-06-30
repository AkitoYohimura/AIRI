require 'redcarpet'
require 'sqlite3'

class Users 
  @id        = nil  
  @name_jap  = nil
  @name_eng  = nil
  @password  = nil
  @email     = nil
  @admin_flg = nil

  attr_accessor :id, :name_jap, :name_eng, :password, :email, :admin_flg

  def initialize(params)
    @id        = params[:id]
    @name_jap  = params[:name_jap]
    @name_eng  = params[:name_eng]
    @password  = params[:password]
    @email     = params[:email]
    @admin_flg = params[:admin_flg]
  end

  def connect_db(db_file)
    database = SQLite3::Database.new("db/#{db_file}")
  end

  def check_login(database)
    @id
    @password
    # sql = "SELECT * FROM users WHERE id='#{id.to_s}' AND password='#{password.to_s}';"
    # sql = "SELECT * FROM users WHERE id='0000' AND password='1234';"
    # database.execute(sql)
  end

  def insert_user(database)
    sql_users  = "INSERT INTO users(id, password, admin_flg) VALUES(#{@id}, #{@password}, #{@admin_flg});"
    sql_detail = "INSERT INTO user_detaile(id, name_jap, name_eng, email, admin_flg) VALUES(#{@id}, #{@name_jap}, #{@name_eng}, #{@email}, #{@admin_flg});"
    database.execute(sql_users)
    database.execute(sql_detail)
  end

  def select_all(database)
    sql = "SELECT * FROM user_detaile"
    database.execute(sql)
  end

end