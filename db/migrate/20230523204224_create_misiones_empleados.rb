class CreateMisionesEmpleados < ActiveRecord::Migration[6.1]
  def change
    create_table :misiones_empleados do |t|
      t.references :misione, null: false, foreign_key: true
      t.references :empleado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
