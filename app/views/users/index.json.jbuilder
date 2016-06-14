json.array!(@users) do |user|
  json.extract! user, :id, :nome, :email, :tipo, :status, :entidade_id, :password_digest
  json.url user_url(user, format: :json)
end
