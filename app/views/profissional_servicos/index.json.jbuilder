json.array!(@profissional_servicos) do |profissional_servico|
  json.extract! profissional_servico, :id, :profissional_id, :lista_preco_servico_id, :entidade_id
  json.url profissional_servico_url(profissional_servico, format: :json)
end
