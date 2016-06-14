json.array!(@reservas) do |reserva|
  json.extract! reserva, :id, :data, :hora_inicio, :nota, :status, :lista_preco_id, :telefone, :profissional_id, :user_id, :entidade_id
  json.url reserva_url(reserva, format: :json)
end
