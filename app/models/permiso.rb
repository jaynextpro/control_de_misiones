class Permiso < ApplicationRecord
  belongs_to :modulo
  belongs_to :role

  validates_presence_of :modulo, :role, message: "no puede estar vacio"
  validates :modulo, uniqueness: {scope: :role, message: "ya existen los permisos con el role"}
end
