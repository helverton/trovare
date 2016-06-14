class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email
      t.integer :tipo
      t.integer :status
      t.references :entidade, index: true, foreign_key: true
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
