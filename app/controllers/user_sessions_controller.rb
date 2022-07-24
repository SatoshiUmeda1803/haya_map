class UserSessionsController < ApplicationController
  protect_from_forgery

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインできませんでした'
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to login_path, success: 'ログアウトしました'
  end

end
