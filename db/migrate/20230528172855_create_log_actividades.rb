class CreateLogActividades < ActiveRecord::Migration[6.1]
  def change
    create_table :log_actividades do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :actividad

      t.timestamps
    end
  end
end
