class UsersController < ApplicationController

  def index
    @users = User.all
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if  @user.update(user_params)
        redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
        render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end

end
