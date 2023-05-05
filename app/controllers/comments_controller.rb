class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.id = post.id
    comment.save
    redirect_to request.referer
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to request.referer
  end

  privates

  def book_comment_params
    params.require(:comment).permit(:comment)
  end

end
