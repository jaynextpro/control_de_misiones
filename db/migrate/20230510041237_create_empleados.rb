class CreateEmpleados < ActiveRecord::Migration[6.1]
  def change
    create_table :empleados do |t|
      t.references :departamento, null: false, foreign_key: true
      t.references :cargo, null: false, foreign_key: true
      t.string :nombres
      t.string :apellidos
      t.string :email
      t.string :contacto

      t.timestamps
    end
  end
end
