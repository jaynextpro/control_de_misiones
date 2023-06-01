class EmpleadosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_empleado, only: %i[ show edit update destroy ]

  # GET /empleados or /empleados.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "empleados")
    @empleados = Empleado.all
  end

  # GET /empleados/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "empleados", "crear")

    @empleado = Empleado.new
  end

  # GET /empleados/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "empleados", "actualizar")
  end

  # POST /empleados or /empleados.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "empleados", "crear")

    @empleado = Empleado.new(empleado_params)

    respond_to do |format|
      if @empleado.save
        ActionCable.server.broadcast("admins", "Se ha creado un empleado, con id "+ @empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un empleado, con id "+ @empleado.id.to_s)

        format.html { redirect_to empleados_url, notice: "Empleado fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @empleado }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @empleado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empleados/1 or /empleados/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "empleados", "actualizar")

    respond_to do |format|
      if @empleado.update(empleado_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un empleado, con id "+ @empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un empleado, con id "+ @empleado.id.to_s)

        format.html { redirect_to empleados_url, notice: "Empleado fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @empleado }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @empleado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empleados/1 or /empleados/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "empleados", "eliminar")

    @empleado.destroy rescue return redirect_to empleados_url, alert: "No se puede eliminar el empleado porque hay usuarios o asignaciones a misiones que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un empleado, con id "+ @empleado.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un empleado, con id "+ @empleado.id.to_s)

      format.html { redirect_to empleados_url, notice: "Empleado fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empleado
      @empleado = Empleado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def empleado_params
      params.require(:empleado).permit(:cargo_id, :departamento_id, :empleado_id, :dui, :nombres, :apellidos, :numero_telefono, :fecha_nacimiento, :foto_presentacion)
    end
end
