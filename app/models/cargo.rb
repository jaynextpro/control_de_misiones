class Cargo < ApplicationRecord
    has_many :usuarios
    
    validates :nombre, presence: {message: "no puede estar vacio"}, uniqueness: {message: "ya existe", case_sensitive: false}
end
