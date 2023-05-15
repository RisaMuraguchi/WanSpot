class PostsController < ApplicationController
before_action :ensure_currect_user, only: [:edit, :update]

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
    @posts = Post.all.order(created_at: :desc)
    @posts = Post.page(params[:page]).per(8)
    @user = current_user
    # 退会している人
    # @posts = Post.includes(:user).where(users: { user_status: false })
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new

    respond_to do |format|
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式
      format.js
    end

  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "更新に成功しました"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end


  # ハッシュタグ
  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
    hashtags = []
    @posts.each do |post|
      hashtags += post.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    end
    @hashtags = hashtags.uniq
  end

  def map
    @posts = Post.all
  end


  private

  def post_params
    params.require(:post).permit(:caption, :image, :user_id, :address, :latitude, :longitude)
  end

  def ensure_currect_user
    @post = Post.find(params[:id])
    unless @post == current_user
      redirect_to user_path(current_user)
    end
  end

end


