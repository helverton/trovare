class Reserva < ActiveRecord::Base
  belongs_to :lista_preco
  belongs_to :profissional
  belongs_to :user
  belongs_to :entidade

  validates :data, :hora_inicio, :lista_preco_id, :profissional_id, :telefone, :user_id, presence: true
  validates :lista_preco_id, :uniqueness => { :scope => [:entidade_id, :hora_inicio, :data] }
end
