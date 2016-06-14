class CreateProfissionals < ActiveRecord::Migration
  def change
    create_table :profissionals do |t|
      t.string :nome
      t.string :email
      t.string :telefone
      t.integer :status
      t.references :entidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
