class Admin::PostsController < ApplicationController

  def show
    # ユーザーIDを取得
    @user = User.find(params[:id])
    # 指定したユーザーに関連する投稿を取得
    @posts = Post.where(user_id: @user.id)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿が削除されました。"
    redirect_to request.referer
  end

end
