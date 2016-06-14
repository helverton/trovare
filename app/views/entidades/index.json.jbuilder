json.array!(@entidades) do |entidade|
  json.extract! entidade, :id, :nome, :cnpj, :latitude, :longitude, :estado, :cidade, :bairro, :cep, :rua, :numero, :telefone, :contato, :status, :ramo_id
  json.url entidade_url(entidade, format: :json)
end
