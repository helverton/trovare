class Servico < ActiveRecord::Base
  validates :nome, :descricao, presence: true
  validates :nome, uniqueness: true
end
