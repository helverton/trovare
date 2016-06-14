json.array!(@ramos) do |ramo|
  json.extract! ramo, :id, :nome, :descricao
  json.url ramo_url(ramo, format: :json)
end
