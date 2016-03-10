class UserController < ApplicationController
  def register
    # render :layout => false
  end

  def record
    users = User.find_by_username(params[:username])
   if !users.nil?
     render 'user/register'
   else
    @newuser = User.new
    @newuser.username = params[:username]
    @newuser.password = params[:password]
    @newuser.first = params[:first]
    @newuser.last = params[:last]
    @newuser.address = params[:address]
    @newuser.zip = params[:zip]
    @newuser.country = params[:country]
    @newuser.email = params[:email]
    @newuser.save
    if !params[:phone1].strip.empty?
      @newphone = Phone.new
      @newphone.number = params[:phone1]
      @newphone.user_id = @newuser.id.to_s
      @newphone.save
    end


    if !params[:phone2].strip.empty?
      @newphone = Phone.new
      @newphone.number = params[:phone2]
      @newphone.user_id = @newuser.id.to_s
      @newphone.save
    end

    if !params[:phone3].strip.empty?
      @newphone = Phone.new
      @newphone.number = params[:phone3]
      @newphone.user_id = @newuser.id.to_s
      @newphone.save
    end
    redirect_to '/user/login'
  end
  end

  def login
  end

  def signin
    users = User.where("username = ? AND password = ?", params[:loginid], params[:loginpw])
    if users.empty?
      render 'user/login'
    elsif users.first.username == params[:loginid] && users.first.password == params[:loginpw]
      session[:userid] = params[:loginid]
      session[:userpw] = params[:loginpw]
      session[:id] = users.first.id
      redirect_to '/user/user_info'
    else
      render 'user/login'
    end
  end

  def signout
    session[:userid] = nil
    session[:password] = nil
    redirect_to '/'
  end

  def user_info
    @username = session[:userid]
    @userinfo = User.where("username = ? AND password = ?", session[:userid], session[:userpw])
    @phones = Phone.where("user_id = ?", session[:id])
  end
end
