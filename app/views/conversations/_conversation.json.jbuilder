json.extract! conversation, :id, :user_id, :body, :created_at, :updated_at
json.url conversation_url(conversation, format: :json)
