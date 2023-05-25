class PostsController < ApplicationController
before_action :ensure_current_user, only: [:edit, :update]
before_action :set_post, only: [:show, :edit, :update, :destroy]


  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id), notice: "投稿に成功しました"
    else
      render :new
    end
  end

  def index
    @posts = Post.page(params[:page]).per(8).order(created_at: :desc)
    @user = current_user
  end

  def show
    @user = @post.user
    @comment = Comment.new

    respond_to do |format|
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式
      format.js
    end

  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "更新に成功しました"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end


  # ハッシュタグ
  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = Post.joins(:hashtags).where(hashtags: { hashname: params[:name] })
    @hashtags = @posts.map { |post| post.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) }.flatten.uniq
  end


  def map
    @posts = Post.all
  end


  private

  def post_params
    params.require(:post).permit(:caption, :image, :user_id, :address, :latitude, :longitude)
  end


  def ensure_current_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to user_path(current_user), notice: "編集権限がありません。"
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end


end


