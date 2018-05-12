class ReplySerializer < ActiveModel::Serializer

  attributes :id, :content, :user_id, :comment_id,
             :created_at, :updated_at, :points
end