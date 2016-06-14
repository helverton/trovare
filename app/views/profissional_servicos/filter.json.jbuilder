json.array!(@profissionais) do |profissional|
  json.extract! profissional, :id, :nome
  #json.url profissional_url(profissional, format: :json)
end
