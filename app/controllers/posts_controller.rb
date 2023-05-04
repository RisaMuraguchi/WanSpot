class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
    @user = current_user
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "You have updated post successfully."
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:caption)
  end

end
