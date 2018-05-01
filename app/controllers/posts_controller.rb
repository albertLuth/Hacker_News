class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :prevent_unauthorized_user_access, only: [:new, :edit]
  before_action :prevent_unauthorized_user_access, except: [:show, :index]
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.where.not(url: '').order('points DESC')
  end

  # GET /newest
  # GET /newest.json
  def newest
    @posts = Post.all.order('created_at DESC')
    render "posts/index"
  end

  # GET /ask
  # GET /ask.json
  def ask
    @posts = Post.all.where(url: '').order('created_at DESC')
    render "posts/index"
  end

  def upvote
    post = Post.find_by(id: params[:id])

    if current_user.upvoted?(post)
      current_user.remove_vote(post)
    elsif current_user.downvoted?(post)
      current_user.remove_vote(post)
      current_user.upvote(post)
    else
      current_user.upvote(post)
    end
    post.calc_hot_score
    redirect_back(fallback_location: root_path)
  end
  def downvote
    post = Post.find_by(id: params[:id])

    if current_user.downvoted?(post)
      current_user.remove_vote(post)
    elsif current_user.upvoted?(post)
      current_user.remove_vote(post)
      current_user.downvote(post)
    else
      current_user.downvote(post)
    end
    post.calc_hot_score
    redirect_back(fallback_location: root_path)
  end
  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = Comment.where("post_id=" + (params[:id])).order("created_at DESC")
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
    @post.user_name = session[:user_name]
    @post.points = 0
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :url, :text, :points)
    end
end
