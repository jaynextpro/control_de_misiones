class Role < ApplicationRecord
    has_many :permisos

    validates :nombre, presence: {message: "no puede estar vacio"}, uniqueness: {message: "ya existe", case_sensitive: false}
end
