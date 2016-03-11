  class UserController < ApplicationController
  def register
    @badpw = flash.now[:alert] = "Password must be between 6 - 20 characters."
  end

  # Record is a method ran from our register button. It validates the password and stores the user
  def record
    # Checks password to see if it contains !, #, or &. Flashes a message if its bad.
    if !params[:password].include?("!") && !params[:password].include?("#") && !params[:password].include?("&")
      @badpw = flash.now[:alert] = "ERROR: Password must contain either !, #, or &."
      render 'user/register'
      return
    end
  # We try to pull an object based on the username input to see if one exist or not
  users = User.find_by_username(params[:username])
  # Tests if 'users' contains an object or is nil. If there is an object the page is re-rendered.
   if !users.nil?
     @badpw = flash.now[:alert] = "Username already taken"
     render 'user/register'
  #If there is not an object each field is saved based off of a corresponding parameter.
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
  #Checkis if phone1 is empty. If not, it saves it to the database.
    if !params[:phone1].strip.empty?
      @newphone = Phone.new
      @newphone.number = params[:phone1]
      @newphone.user_id = @newuser.id.to_s
      @newphone.save
    end
    #Checkis if phone2 is empty. If not, it saves it to the database.
    if !params[:phone2].strip.empty?
      @newphone = Phone.new
      @newphone.number = params[:phone2]
      @newphone.user_id = @newuser.id.to_s
      @newphone.save
    end
    #Checkis if phone3 is empty. If not, it saves it to the database.
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
#Runs from login page Sign In button.
  def signin
#Returns each object with matching username and password base off of entered parameters into an array. There will only ever be one at most
    users = User.where("username = ? AND password = ?", params[:loginid], params[:loginpw])
#Check if the array is empty. If it is flash and re-render happens.
    if users.empty?
      @nope = flash.now[:alert] = "Incorrect login info"
      render 'user/login'
  #if it is not empty, this stores the entered user id and password into a cooooookie and redirects to user/user_info
    else
      session[:userid] = params[:loginid]
      session[:userpw] = params[:loginpw]
      session[:id] = users.first.id
      redirect_to '/user/user_info'
    end
  end

  #on logout saves sessions as nil and redirects to login page
  def signout
    params[:loginid] = nil
    params[:loginpw] = nil
    session[:userid] = nil
    session[:password] = nil
    session[:id] = nil
    redirect_to '/'
  end


#sets instance variables to use to access database on the info page
  def user_info
    @username = session[:userid]
    @userinfo = User.where("username = ? AND password = ?", session[:userid], session[:userpw])
    @phones = Phone.where("user_id = ?", session[:id])
  #This is worthless.
    if session[:userid] == nil || session[:id] == nil || session[:userpw] == nil
      redirect_to '/'
    end
  end
end
