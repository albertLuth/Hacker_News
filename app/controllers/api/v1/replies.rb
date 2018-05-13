module API
  module V1
    class Replies < Grape::API
      include API::V1::Defaults

      resource :replies do
        desc "Return all replies"
        get "", root: :replies do
          Reply.all.order('points')
        end

        desc "Return a reply"
        params do
          requires :id, type: String, desc: "ID of the
              reply"
        end
        get ":id" do
          Reply.where(id: permitted_params[:id]).first!
        end

        desc "Create a new reply"
        params do
          requires :content, type: String
          requires :comment_id, type: String
        end
        post "add" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          user = User.where(uid: token).first
          if user != nil
            @reply = Reply.new(params)
            @reply.user_id = user.id
            @reply.points = 0
            @reply.save
          else
            error!('Forbidden.', 403)
          end
        end

        desc "Edit a reply"
        params do
          requires :id, type: String, desc: 'ID of the reply'
          requires :content, type: String
        end
        put ":id" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          @user = User.where(uid: token).first
          @reply = Reply.where(id: permitted_params[:id]).first!
          if @user && @user.id == @reply.user_id
            @reply.content = params[:content]
            @reply.save
          else
            error!('Forbidden.', 403)
          end
        end

        desc "Upvote a reply"
        params do
          requires :id, type: String, desc: 'ID of the reply'
        end
        post ":id/upvote" do
          token = request.headers["Authentication"]
          @user = User.where(uid: token).first
          if @user != nil
            @reply = reply.where(id: permitted_params[:id]).first!
            if @user.id != @reply.user_id
              if !@user.upvoted?(@reply)
                @user.upvote(@reply)
              end
              @reply.calc_hot_score
            else
              error!('Unauthorized.', 401)
            end
          else
            error!('Unauthorized.', 401)
          end
        end

        desc "Downvote a reply"
        params do
          requires :id, type: String, desc: 'ID of the reply'
        end
        post ":id/downvote" do
          token = request.headers["Authentication"]
          @user = User.where(uid: token).first
          if @user != nil
            @reply = Reply.where(id: permitted_params[:id]).first!
            if @user.id != @reply.user_id
              if @user.upvoted?(@reply)
                @user.remove_vote(@reply)
              end
              @reply.calc_hot_score
            else
              error!('Denied AutoVote.',401)
            end
          else
            error!('Unauthorized.', 401)
          end
        end

        desc "Delete a reply"
        params do
          requires :id, type: String, desc: 'ID of the reply'
        end
        delete ":id" do
          token = request.headers["Authentication"]
          if token == nil
            error!('Unauthorized.', 401)
          end
          @user = User.where(uid: token).first
          @reply = Reply.where(id: permitted_params[:id]).first!
          if @user && @user.id == @reply.user_id
            @reply.destroy
          else
            error!('Forbidden.', 403)
          end
        end
      end
    end
  end
end
