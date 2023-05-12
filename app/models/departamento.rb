class Departamento < ApplicationRecord
    has_many :empleados, dependent: :destroy
end
