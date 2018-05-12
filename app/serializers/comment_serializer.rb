class CommentSerializer < ActiveModel::Serializer

  attributes :id, :content, :user_id,
             :created_at, :updated_at, :user_name, :points
end