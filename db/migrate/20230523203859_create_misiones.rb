class CreateMisiones < ActiveRecord::Migration[6.1]
  def change
    create_table :misiones do |t|
      t.string :nombre, null: false
      t.string :descripcion
      t.date :fecha_inicio, null: false
      t.date :fecha_final, null: false

      t.timestamps
    end
  end
end
