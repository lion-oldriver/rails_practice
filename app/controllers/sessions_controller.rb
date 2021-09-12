class SessionsController < ApplicationController
  before_action :reject_user



  def reject_user
    @user = User.find_by(name: params[:name])
    if @user.is_deleted == true
        flash[:error] = "退会済みです。"
        redirect_to new_user_session_path
    else
      flash[:error] = "必須項目を入力してください。"
    end
  end
end
