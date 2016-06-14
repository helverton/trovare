json.array!(@horarios) do |horario|
  json.extract! horario, :id, :dia_semana, :hora_inicio, :hora_fim, :data, :entidade_id
  json.url horario_url(horario, format: :json)
end
