class CreateReservas < ActiveRecord::Migration
  def change
    create_table :reservas do |t|
      t.date :data
      t.time :hora_inicio
      t.integer :nota
      t.integer :status
      t.string :telefone
      t.references :lista_preco, index: true, foreign_key: true
      t.references :profissional, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :entidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
