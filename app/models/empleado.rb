class Empleado < ApplicationRecord
  belongs_to :departamento
  belongs_to :cargo
  has_one :usuario, required: false
  has_many :misiones_empleados
  has_many :misiones, through: :misiones_empleados
  has_one_attached :foto_presentacion

  validates_presence_of :departamento, :cargo, :nombres, :apellidos, :fecha_nacimiento, :foto_presentacion, message: "no puede estar vacio"
  validates :numero_telefono, format: {with: /\A([6-7]{1}\d{3}-\d{4}|[6-7]{1}\d{7})\z/, message: "es invalido"}, presence: { message: "no puede estar vacio" }, uniqueness: {message: "ya esta en uso", case_sensitive: false}
  validates :dui, format: {with: /\A(\d{8}-\d{1}|\d{9})\z/, message: "es invalido"}, presence: { message: "no puede estar vacio" }, uniqueness: {message: "ya esta en uso", case_sensitive: false}
  validate :fecha_nacimiento_valida
  validate :foto_presentacion_valida

  default_scope -> { where(activo: true) }

    def fecha_nacimiento_valida
        unless try(:fecha_nacimiento).present? && try(:fecha_nacimiento) < (Date.today - 18.years)
            errors[:base] << "Debe ser mayor de edad"
        end
    end

    def foto_presentacion_valida
        if foto_presentacion.present? && !foto_presentacion.content_type.in?(%('image/jpeg image/png'))
            errors.add(:foto_presentacion, "debe ser de tipo jpeg o png!")
        end
    end

    def destroy
        update_attribute :activo, false
    end

    def nombre_completo
        nombres + ", " + apellidos
    end

    def presentacion 
        dui + " - " + nombre_completo
    end
end
