class Misione < ApplicationRecord
    has_many :misiones_empleados
    has_many :empleados, through: :misiones_empleados

    validates :nombre, uniqueness: {message: "ya existe"}
    validate :fechas_correctas

    def fechas_correctas
        unless try(:fecha_inicio) && try(:fecha_final) && (fecha_inicio < fecha_final)
            errors[:base] << "Las fechas ingresadas no son correctas"
        end
    end
end
