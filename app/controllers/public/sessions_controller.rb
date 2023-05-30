# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_withdraw_user, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    posts_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def reject_withdraw_user
    @user = User.find_by(email: params[:user][:email])
      return if !@user
        if @user.valid_password?(params[:user][:password]) && @user.user_status == false
        flash[:notice] = "退会済みの為、再登録が必要です。"
        redirect_to new_user_registration_path
        end
  end

end
