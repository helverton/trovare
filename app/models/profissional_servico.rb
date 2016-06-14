class ProfissionalServico < ActiveRecord::Base
  belongs_to :profissional
  belongs_to :lista_preco
  belongs_to :entidade

  validates :lista_preco, :uniqueness => { :scope => :entidade_id, :scope => :profissional_id }
end
