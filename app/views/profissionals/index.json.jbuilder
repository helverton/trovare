json.array!(@profissionals) do |profissional|
  json.extract! profissional, :id, :nome, :email, :telefone, :status, :entidade_id
  json.url profissional_url(profissional, format: :json)
end
