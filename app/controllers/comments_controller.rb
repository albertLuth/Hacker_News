class CommentsController < ApplicationController
  protect_from_forgery
  before_action :set_comment, only: [:show, :edit, :update, :destroy]


  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end
  def upvote
    comment = Comment.find_by(id: params[:id])

    if current_user.upvoted_comment?(comment)
      current_user.remove_comment_vote(comment)
    elsif current_user.downvoted_comment?(comment)
      current_user.remove_comment_vote(comment)
      current_user.upvote_comment(comment)
    else
      current_user.upvote_comment(comment)
    end
    comment.calc_hot_score
    redirect_back(fallback_location: root_path)
  end

  def downvote
    comment = Comment.find_by(id: params[:id])

    if current_user.downvoted_comment?(comment)
      current_user.remove_comment_vote(comment)
    elsif current_user.upvoted_comment?(comment)
      current_user.remove_comment_vote(comment)
      current_user.downvote_comment(comment)
    else
      current_user.downvote_comment(comment)
    end
    comment.calc_hot_score
    redirect_back(fallback_location: root_path)
  end
  # GET /comments/1/edit
  def edit
  end


  # POST /comments
  # POST /comments.json
  def create

    auth_user = current_user
    begin
      tmp = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
      if (tmp)
        puts tmp.name
        auth_user = tmp
      end
    rescue

    end

    # if auth_user
    @comment = Comment.new(comment_params)
      # @comment.user = auth_user
      # @comment.post = comment_params[3]


    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        # format.html { redirect_to @comment.post, notice: 'Comment not created.' }
        format.json { render json: :new, status: :unprocessable_entity }
      end
    end
    # else
    #   redirect_to "/auth/google_oauth2"
    # end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.post, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @post = @comment.post
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :post_id, :points)
    end
end
