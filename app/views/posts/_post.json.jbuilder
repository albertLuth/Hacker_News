json.extract! post, :id, :user_id, :title, :url, :text, :points, :created_at, :updated_at
json.url post_url(post, format: :json)
