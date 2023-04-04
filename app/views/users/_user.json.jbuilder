json.extract! user, :id, :name, :phone_number, :password_digest, :code, :verified, :created_at, :updated_at
json.url user_url(user, format: :json)
