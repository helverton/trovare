json.array!(@servicos) do |servico|
  json.extract! servico, :id, :nome, :descricao, :status
  json.url servico_url(servico, format: :json)
end
