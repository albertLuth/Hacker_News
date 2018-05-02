class RepliesController < ApplicationController
  protect_from_forgery
  before_action :set_reply, only: [:show, :edit, :update, :destroy]

  # GET /replies
  # GET /replies.json
  def index
    @replies = Reply.all
  end

  # GET /replies/1
  # GET /replies/1.json
  def show
  end

  # GET /replies/new
  def new
    @reply = Reply.new
  end
  def upvote
    reply = Reply.find_by(id: params[:id])

    if current_user.upvoted_reply?(reply)
      current_user.remove_reply_vote(reply)
    elsif current_user.downvoted_reply?(reply)
      current_user.remove_reply_vote(reply)
      current_user.upvote_reply(reply)
    else
      current_user.upvote_reply(reply)
    end
    reply.calc_hot_score
    redirect_back(fallback_location: root_path)
  end

  def downvote
    reply = Reply.find_by(id: params[:id])

    if current_user.downvoted_reply?(reply)
      current_user.remove_reply_vote(reply)
    elsif current_user.upvoted_reply?(reply)
      current_user.remove_reply_vote(reply)
      current_user.downvote_reply(reply)
    else
      current_user.downvote_reply(reply)
    end
    reply.calc_hot_score
    redirect_back(fallback_location: root_path)
  end
  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  # POST /replies.json
  def create
    @reply = Reply.new(reply_params)

    respond_to do |format|
      if @reply.save
        format.html { redirect_to @reply.comment.post, notice: 'Reply was successfully created.' }
        format.json { render :show, status: :created, location: @reply }
      else
        format.html { render :new }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1
  # PATCH/PUT /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply.comment.post, notice: 'Reply was successfully updated.' }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.json
  def destroy
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to replies_url, notice: 'Reply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reply_params
      params.require(:reply).permit(:content, :user_id, :comment_id, :points)
    end
end
