class PostSerializer < ActiveModel::Serializer

    attributes :id, :title, :url, :text, :user_id, 
              :created_at, :updated_at, :user_name, :points, :hot_score
  end  