class ListaPreco < ActiveRecord::Base
  belongs_to :servico
  belongs_to :entidade

  validates :servico_id, :preco, :tempo, presence: true
  validates :servico_id, :uniqueness => { :scope => :entidade_id }
end
