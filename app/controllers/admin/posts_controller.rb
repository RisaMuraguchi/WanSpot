class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def show
    # ユーザーIDを取得
    @user = User.find(params[:user_id])
    # 指定したユーザーに関連する投稿を取得
    @posts = Post.where(user_id: @user.id)
  end

  def destroy
    @post = Post.find(params[:user_id])
    @post.destroy
    flash[:notice] = "投稿が削除されました。"
    redirect_to request.referer
  end

end
