class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id), notice: "You have created post successfully."
    else
      render :new
    end
  end

  def index
    @posts = Post.all
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
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる（詳しくは参照記事をご覧ください）
      format.js
    end

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

  #キーワード検索
  def search
    # 入力した検索ワードをparams[:keyword]で取得
    if params[:keyword].present?
    # 投稿のキャプションで検索
      @posts = Post.where('caption LIKE ?', "%#{params[:keyword]}%")
      @keyword = params[:keyword]
    else
    # 何も入力せずに検索ボタンをクリックした場合は全ての投稿を取得
      @posts = Post.all
    end
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

  # 住所の自動補完
  # def autocomplete
  #   client = GooglePlaces::Client.new(ENV['SECRET_KEY'])
  #   autocomplete = client.predictions_by_input(params[:term], lat: 0, lng: 0, radius: 20000000, types: 'geocode', language: :ja)
  #   render json: "{test:test}"
  #   # render json: autocomplete["predictions"][0]["description"].split(",")
  # end

  private

  def post_params
    params.require(:post).permit(:caption, :image, :user_id, :address, :latitude, :longitude)
  end

end


