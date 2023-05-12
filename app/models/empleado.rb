class Empleado < ApplicationRecord
  belongs_to :departamento
  belongs_to :cargo
end
