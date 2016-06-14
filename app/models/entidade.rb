class Entidade < ActiveRecord::Base
	belongs_to :ramo

	validates :nome, :ramo_id, presence: true
	validates :nome, uniqueness: true
end
