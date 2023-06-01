class Usuario < ApplicationRecord
  belongs_to :empleado, optional: true
  belongs_to :role

  devise :database_authenticatable,
         :recoverable, :rememberable

  validates :role, presence: "no puede estar vacio"
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, message: "es invalido"}, presence: { message: "no puede estar vacio" }, uniqueness: {message: "ya esta en uso", case_sensitive: false}
  validates :password, format: {with: /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}\z/, message: "debe tener al menos 8 caracteres, contener al menos una letra mayúscula, un número y un carácter especial"}
  validate :validar_passwords
  # validates_uniqueness_of :empleado, message: "ya esta en uso", if: -> { empleado.present? }

  validates_uniqueness_of :empleado, allow_blank: true, message: "ya esta en uso"

  default_scope -> { where(activo: true) }

  def validar_passwords 
    if password != password_confirmation 
        errors[:base] << "Las contrasenas no coinciden"

        return false
    end
  end

  def es_admin?
    return (role.nombre == "admin")
  end

  def destroy
    update_attribute :activo, false
  end

end
