class CreateListaPrecos < ActiveRecord::Migration
  def change
    create_table :lista_precos do |t|
      t.float :preco
      t.integer :tempo
      t.integer :status
      t.references :servico, index: true, foreign_key: true
      t.references :entidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
