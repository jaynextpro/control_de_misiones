class CreateDepartamentos < ActiveRecord::Migration[6.1]
  def change
    create_table :departamentos do |t|
      t.string :nombre, null: false

      t.timestamps
    end
  end
end
