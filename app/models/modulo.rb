class Modulo < ApplicationRecord
    has_many :permisos, dependent: :delete_all
end
