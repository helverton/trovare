class CreateEntidades < ActiveRecord::Migration
  def change
    create_table :entidades do |t|
      t.string :nome
      t.string :cnpj
      t.string :latitude
      t.string :longitude
      t.string :estado
      t.string :cidade
      t.string :bairro
      t.string :cep
      t.string :rua
      t.integer :numero
      t.string :telefone
      t.string :contato
      t.integer :status
      t.references :ramo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
