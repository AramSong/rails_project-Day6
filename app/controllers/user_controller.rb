class UserController < ApplicationController
  def index
    @Users = User.all
    @current_user = User.find(session[:current_user]) if session[:current_user]
  end

  def sign_up

  end
  
  def create
    new = User.new
    new.user_id = params[:user_id]
    new.password = params[:password]
    new.ip_address = request.ip
    new.save
    
    redirect_to "/user/#{new.id}"
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
 
  def update
    user = User.find(params[:id])
    user.user_id = params[:user_id]
    user.password = params[:password]
    user.ip_address = request.ip
    user.save
    
    redirect_to "/users"
  end

  def sign_in
    #로그인 되어있는지 확인하고,
    #로그인 되어있으면 원래 페이지로 돌아가기
  end
  
  def login
    #실제로 유저가 입력한 id,pw를 바탕으로
    #실제로 로그인이 이루어지는 곳
    id=params[:user_id]
    password=params[:password]
    user = User.find_by_user_id(id) 
    if !user.nil? and user.password.eql?(password)
    #해당 user_id로 가입한 유저가 있고, 패스워드도 일치하는 경우
      session[:current_user] = user.id
    #login_user 이름으로 session에 저장됨.
      flash[:success] ="로그인에 성공했습니다."
      redirect_to '/users'
    else 
    #등록된 id가 아니거나, 비밀번호가 일치하지 않는 경우
      flash[:error] = "가입된 유저가 아니거나, 비밀번호가 틀립니다."
      redirect_to '/sign_in'
    end
    
  end
  
  def logout
    #session.delet(:key이름)
    session.delete(:current_user)
    flash[:warning] = "로그아웃"
    
    redirect_to '/users'
  end
end
