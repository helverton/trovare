class CreateHorarios < ActiveRecord::Migration
  def change
    create_table :horarios do |t|
      t.string :dia_semana
      t.time :hora_inicio
      t.time :hora_fim
      t.date :data
      t.references :entidade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
