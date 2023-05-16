class UsersController < ApplicationController
  before_action :ensure_currect_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]
  before_action :set_user, only: [:show, :edit, :update, :likes]


  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def update
    if  @user.update(user_params)
        redirect_to user_path(@user.id), notice: "更新に成功しました."
    else
        render :edit
    end
  end

  def likes
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

  def ensure_currect_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

end
