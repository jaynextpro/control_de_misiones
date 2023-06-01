class LogActividadesController < ApplicationController
    before_action :authenticate_usuario!

  # GET /misiones_empleados or /misiones_empleados.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless current_usuario.present? && current_usuario.es_admin?

    @log_actividades = LogActividade.all
  end
 
end
