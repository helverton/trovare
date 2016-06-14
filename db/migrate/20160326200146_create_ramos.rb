class CreateRamos < ActiveRecord::Migration
  def change
    create_table :ramos do |t|
      t.string :nome
      t.string :descricao

      t.timestamps null: false
    end
  end
end
