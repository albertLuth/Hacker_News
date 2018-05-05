module API  
    module V1
      class Posts < Grape::API
        include API::V1::Defaults
  
        resource :posts do
          desc "Return all posts"
          get "", root: :posts do
            Post.all
          end
  
          desc "Return a post"
          params do
            requires :id, type: String, desc: "ID of the post"
          end
          get ":id", root: "post" do
            Post.where(id: permitted_params[:id]).first!
          end

          desc "Create a new post"
          params do
            requires :title, type: String
            requires :url, type: String
            requires :text, type: String 
          end
          post "add" do
            @post = Post.new(params)
            @post.user_id = 1
            @post.user_name = "Albert Masip"
            @post.points = 0
            @post.save
          end
        end
      end
    end
  end 