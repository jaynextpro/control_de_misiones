class CreatePermisos < ActiveRecord::Migration[6.1]
  def change
    create_table :permisos do |t|
      t.references :modulo, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.boolean :activo
      t.boolean :crear
      t.boolean :actualizar
      t.boolean :eliminar

      t.timestamps
    end
  end
end
