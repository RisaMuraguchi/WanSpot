class CommentsController < ApplicationController
  before_action :ensure_current_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = post.id
    @comment.save
  end


  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def ensure_current_user
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      redirect_to post_path(params[:post_id])
    end
  end

end
