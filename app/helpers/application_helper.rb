module ApplicationHelper
    def acceso_a_modulo?(usuario, nombre_modulo)
        @role_acceso = usuario.try(:role)
        return true if (@role_acceso.present? && @role_acceso.nombre == "admin")

        @modulo_acceso = Modulo.find_by(nombre: nombre_modulo)

        if @role_acceso.present? && @modulo_acceso.present?
            @permiso_acceso = Permiso.where(activo: true).find_by(role_id: @role_acceso.id, modulo_id: @modulo_acceso.id)
            if @permiso_acceso.present?
                return true
            end 
        end

        return false
    end

    def acceso_a_accion_de_modulo?(usuario, nombre_modulo, accion)
        if (acceso_a_modulo?(usuario, nombre_modulo))
            if @role_acceso.nombre == "admin" || (@permiso_acceso.present? && @permiso_acceso.read_attribute(accion))
                return true 
            end
        end
           
        return false
    end
end
