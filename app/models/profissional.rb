class Profissional < ActiveRecord::Base
  belongs_to :entidade

  validates :nome, presence: true
  validates :nome, :uniqueness => { :scope => :entidade_id }
end
