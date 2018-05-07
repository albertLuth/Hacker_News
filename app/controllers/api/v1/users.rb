module API  
    module V1
      class Users < Grape::API
        include API::V1::Defaults
  
        resource :users do  
          desc "Return a user"
          params do
            requires :id, type: String, desc: "ID of the user"
          end
          get ":id", root: "user" do
            User.where(id: permitted_params[:id]).first!
          end

          desc "Edit a user"
          put "" do
            token = request.headers["Authentication"]
            @user = User.where(uid: token).first
            if @user
              @user.name = params[:name] == nil ? @user.name : params[:name]
              @user.email = params[:email] == nil ? @user.email : params[:email]
              @user.about = params[:about] == nil ? @user.about :  params[:about]
              @user.save
            else 
              error!('Unauthorized.', 401)
            end
          end
        end
      end
    end
  end 