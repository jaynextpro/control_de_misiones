class MisionesEmpleadosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_misiones_empleado, only: %i[ show edit update destroy ]

  # GET /misiones_empleados or /misiones_empleados.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "misiones_empleados")

    @misiones_empleados = MisionesEmpleado.all
    @misiones_empleados = @misiones_empleados.where("empleado_id = ?", params[:empleado]) if params[:empleado].present?
    @misiones_empleados = @misiones_empleados.where("misione_id = ?", params[:mision]) if params[:mision].present?
  end

  def generar_reporte
    @misiones_empleados = MisionesEmpleado.all
    @misiones_empleados = @misiones_empleados.where("empleado_id = ?", params[:empleado]) if params[:empleado].present?
    @misiones_empleados = @misiones_empleados.where("misione_id = ?", params[:mision]) if params[:mision].present?
    
    if @misiones_empleados.present?
        render xlsx: "reporte_de_empleados_en_misiones", filename: "empleados_en_misiones_#{DateTime.now}.xlsx"
    else
        redirect_to request.referrer, alert: "No existen asignaciones"
    end
  end

  # GET /misiones_empleados/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones_empleados", "crear")

    @misiones_empleado = MisionesEmpleado.new
  end

  # GET /misiones_empleados/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones_empleados", "actualizar")
  end

  # POST /misiones_empleados or /misiones_empleados.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones_empleados", "crear")

    @misiones_empleado = MisionesEmpleado.new(misiones_empleado_params)

    respond_to do |format|
      if @misiones_empleado.save
        ActionCable.server.broadcast("admins", "Se ha creado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s)

        format.html { redirect_to misiones_empleados_url, notice: "Asignacion fue creada satisfactoriamente" }
        format.json { render :show, status: :created, location: @misiones_empleado }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @misiones_empleado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /misiones_empleados/1 or /misiones_empleados/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones_empleados", "actualizar")

    respond_to do |format|
      if @misiones_empleado.update(misiones_empleado_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s)

        format.html { redirect_to misiones_empleados_url, notice: "Asignacion fue actualizada satisfactoriamente" }
        format.json { render :show, status: :ok, location: @misiones_empleado }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @misiones_empleado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /misiones_empleados/1 or /misiones_empleados/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones_empleados", "eliminar")

    @misiones_empleado.destroy

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado una asignacion de empleado a mision, con id "+ @misiones_empleado.id.to_s)
      format.html { redirect_to misiones_empleados_url, notice: "Asignacion fue eliminada satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_misiones_empleado
      @misiones_empleado = MisionesEmpleado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def misiones_empleado_params
      params.require(:misiones_empleado).permit(:misione_id, :empleado_id)
    end
end
