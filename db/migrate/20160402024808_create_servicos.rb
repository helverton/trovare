class CreateServicos < ActiveRecord::Migration
  def change
    create_table :servicos do |t|
      t.string :nome
      t.string :descricao
      t.integer :tempo
      t.float :preco
      t.integer :status

      t.timestamps null: false
    end
  end
end
