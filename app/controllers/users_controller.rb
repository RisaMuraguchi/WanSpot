class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]
  # before_action :set_user, only: [:show, :edit, :update, :likes]

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

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    @like_posts = Post.find(likes)
    if @like_posts.empty?
      @message = "いいねした投稿はありません"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  # def set_user
  #   @user = User.find(params[:id])
  # end

end
