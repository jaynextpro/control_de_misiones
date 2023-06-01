class MisionesEmpleado < ApplicationRecord
  belongs_to :misione
  belongs_to :empleado

  validates_presence_of :misione, :empleado, message: "no puede estar vacio"
  validates :empleado, uniqueness: {scope: :misione, message: ": ya esta asociado con la mision"}
end
