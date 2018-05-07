module API  
  module V1
    class Posts < Grape::API
      include API::V1::Defaults

      resource :posts do
        desc "Return all posts with url sorted by points"
        get "", root: :posts do
          Post.all.where.not(url: '').order('points DESC')
        end

        desc "Return all posts sorted by date"
        get "newest", root: :posts do
          Post.all.order('created_at DESC')
        end

        desc "Return all questions sorted by date"
        get "ask", root: :posts do
          Post.all.where(url: '').order('created_at DESC')
        end

        desc "Return a post"
        params do
          requires :id, type: String, desc: "ID of the 
            post"
        end
        get ":id" do
          Post.where(id: permitted_params[:id]).first!
        end

        desc "Create a new post"
        params do
          requires :title, type: String
        end
        post "add" do
          token = request.headers["Authentication"]
          user = User.where(uid: token).first
          if user != nil
            @post = Post.new(params)
            @post.url = @post.url == nil ? '' : @post.url
            @post.text = @post.text == nil ? '': @post.text
            @post.user_id = user.id
            @post.user_name = user.name
            @post.points = 0
            @post.save
          else 
            error!('Unauthorized.', 401)
          end
        end

        desc "Delete a post"
        params do
          requires :id, type: String, desc: 'ID of the post'
        end
        delete ":id" do
          token = request.headers["Authentication"]
          @user = User.where(uid: token).first
          @post = Post.where(id: permitted_params[:id]).first!
          if @user && @user.id == @post.user_id
            @post.destroy
          else 
            error!('Unauthorized.', 401)
          end
        end

        desc "Edit a post"
        params do
          requires :id, type: String, desc: 'ID of the post'
          requires :title, type: String
        end
        put ":id" do
          token = request.headers["Authentication"]
          @user = User.where(uid: token).first
          @post = Post.where(id: permitted_params[:id]).first!
          if @user && @user.id == @post.user_id
            @post.title = params[:title]
            @post.url = params[:url] == nil ? '' : params[:url]
            @post.text = params[:text] == nil ? '':  params[:text]
            @post.save
          else 
            error!('Unauthorized.', 401)
          end
        end
      end
    end
  end
end 