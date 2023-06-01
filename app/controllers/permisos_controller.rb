class PermisosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_permiso, only: %i[ show edit update destroy ]

  # GET /permisos or /permisos.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "permisos")

    @permisos = Permiso.all
  end

  # GET /permisos/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "permisos", "crear")

    @permiso = Permiso.new
  end

  # GET /permisos/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "permisos", "actualizar")
  end

  # POST /permisos or /permisos.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "permisos", "crear")

    @permiso = Permiso.new(permiso_params)

    respond_to do |format|
      if @permiso.save
        ActionCable.server.broadcast("admins", "Se ha creado un permiso, con id "+ @permiso.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un permiso, con id "+ @permiso.id.to_s)

        format.html { redirect_to permisos_url, notice: "Permiso fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @permiso }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permiso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permisos/1 or /permisos/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "permisos", "actualizar")

    respond_to do |format|
      if @permiso.update(permiso_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un permiso, con id "+ @permiso.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un permiso, con id "+ @permiso.id.to_s)

        format.html { redirect_to permisos_url, notice: "Permiso fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @permiso }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permiso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permisos/1 or /permisos/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "permisos", "eliminar")

    @permiso.destroy

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un permiso, con id "+ @permiso.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un permiso, con id "+ @permiso.id.to_s)

      format.html { redirect_to permisos_url, notice: "Permiso fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permiso
      @permiso = Permiso.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def permiso_params
      params.require(:permiso).permit(:modulo_id, :role_id, :activo, :crear, :actualizar, :eliminar)
    end
end
