class CreateProfissionalServicos < ActiveRecord::Migration
  def change
    create_table :profissional_servicos do |t|
      t.references :profissional, index: true, foreign_key: true
      t.references :lista_preco, index: true, foreign_key: true
      t.references :entidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
