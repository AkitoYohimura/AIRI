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
    @admin_flg = 0
    # @admin_flg = params[:admin_flg]
  end

  def connect_db(db_file)
    database = SQLite3::Database.new("db/#{db_file}")
  end

  def check_login(database)
    sql = "SELECT * FROM users WHERE id='#{@id}' AND password='#{@password}';"
    # sql = "SELECT * FROM users WHERE id='0000' AND password='1234';"
    database.execute(sql)
  end

  def insert_user(database)
    sql_users  = "INSERT INTO users(id, password, admin_flg) VALUES('#{@id}', '#{@password}', '#{@admin_flg}');"
    sql_detaile = "INSERT INTO user_detaile(id, name_jap, name_eng, email, admin_flg) VALUES('#{@id}', '#{@name_jap}', '#{@name_eng}', '#{@email}', #{@admin_flg});"
    database.execute(sql_users)
    database.execute(sql_detaile)
    # return "INSERT"
    # return sql_detaile
  end

  def select_all(database)
    sql = "SELECT * FROM user_detaile;"
    database.execute(sql)
  end

  def select_detaile(database)
    sql = "SELECT * FROM user_detaile WHRER id = #{@id};"
    database.execute(sql)
  end

  def delete_user(database)
    sql_users   = "DELETE FROM users WHERE id = '#{@id}';"
    sql_detaile = "DELETE FROM user_detaile WHERE id = '#{@id}';"
    database.execute(sql_users)
    database.execute(sql_detaile)
  end

  def update_user(database)
    sql_users   = "UPDATE users SET id='#{@id}', password='#{@password}', admin_flg='#{@admin_flg}' WHERE id = '#{@id}');"
    sql_detaile = "UPDATE user_detaile SET id='#{@id}', name_jap='#{@name_jap}', name_eng='#{@name_eng}', email='#{@email}', admin_flg=#{@admin_flg}' WHERE id = '#{@id}';"
    database.execute(sql_users)
    database.execute(sql_detaile)
  end
end