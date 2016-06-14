json.array!(@lista_precos) do |lista_preco|
  json.extract! lista_preco, :id, :preco, :tempo, :status, :servico_id, :entidade_id
  json.url lista_preco_url(lista_preco, format: :json)
end
