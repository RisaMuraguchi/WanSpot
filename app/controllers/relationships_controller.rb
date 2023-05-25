class RelationshipsController < ApplicationController
  before_action :set_user, only: [:create, :destroy, :followings, :followers]

  # フォローするとき
  def create
    current_user.follow(@user)
    redirect_to request.referer
  end

  # フォロー外すとき
  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    @users = @user.followers
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
