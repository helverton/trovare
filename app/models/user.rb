class User < ActiveRecord::Base
  belongs_to :entidade
  has_secure_password
  
  validates :nome, :email, :password, :password_confirmation, presence: true
  validates :nome, :email, uniqueness: true
end
