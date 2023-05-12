class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :role
      t.string :descripcion

      t.timestamps
    end
  end
end
