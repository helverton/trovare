class Horario < ActiveRecord::Base
  belongs_to :entidade
  validates :dia_semana, :hora_inicio, :hora_fim, :entidade_id, presence: true

  #validates :data, :uniqueness => { :scope => :entidade_id, :scope => :dia_semana }
end
