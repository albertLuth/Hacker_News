module API
  module V1
    class Comments < Grape::API
      include API::V1::Defaults

      resource :comments do
        desc "Return a comment"
        params do
          requires :id, type: String, desc: "ID of the comment"
        end
        get ":id" do
          Comment.where(id: permitted_params[:id]).first!
        end

        desc "Return all comments from a post"
        params do
          requires :id, type: String, desc: "ID of the post"
        end
        get ":id" do
          Comment.all.where(post_id: permitted_params[:id]).order('points DESC')
        end

        desc "Create a new comment"
        params do
          requires :id, type: String, desc: "ID of the post"
        end
        post "add" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          user = User.where(uid: token).first
          if user != nil
            @comment = Comment.new(params)
            @comment.post_id = :id
            @comment.user_id = user.id
            @comment.user_name = user.name
            @comment.points = 0
            @comment.save
          else
            error!('Forbidden.', 403)
          end
        end

        desc "Delete a comment"
        params do
          requires :id, type: String, desc: "ID of the comment"
        end
        delete ":id" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          @user = User.where(uid: token).first
          @comment = Comment.where(id: permitted_params[:id]).first!
          if @user && @user.id == @comment.user_id
            @comment.destroy
          else
            error!('Forbidden.', 403)
          end

        end

        desc "Edit a comment"
        params do
          requires :id, type: String, desc: "ID of the comment"
        end
        put ":id" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          @user = User.where(uid: token).first
          @comment = Post.where(id: permitted_params[:id]).first!
          if @user && @user.id == @comment.user_id
            @comment.content = params[:content]
            @comment.save
          else
            error!('Forbidden.', 403)
          end
        end


        desc "Upvote a comment"
          params do
            requires :id, type: String, desc: "ID of the comment"
          end
          post ":id/upvote" do
            token = request.headers["Authentication"]
            @user = User.where(uid: token).first
            if @user != nil
              @comment = Comment.where(id: permitted_params[:id]).first!
              if @user.id != @comment.user_id
                if !@user.upvoted?(@comment)
                  @user.upvote(@comment)
                end
                @comment.calc_hot_score
              else
                error!('Unauthorized.', 401)
              end
            else
              error!('Unauthorized.', 401)
            end
          end

        desc "Downvote a comment"
          params do
            requires :id, type: String, desc: "ID of the comment"
          end
          post ":id/downvote" do
            token = request.headers["Authentication"]
            @user = User.where(uid: token).first
            if @user != nil
              @comment = Comment.where(id: permitted_params[:id]).first!
              if @user.id != @comment.user_id
                if @user.upvoted?(@comment)
                  @user.remove_vote(@comment)
                end
                @comment.calc_hot_score
              else
                error!('Denied AutoVote.',401)
              end
            else
              error!('Unauthorized.', 401)
            end
          end
      end
    end
  end
end