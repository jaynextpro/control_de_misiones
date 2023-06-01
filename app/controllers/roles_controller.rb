class RolesController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_role, only: %i[ show edit update destroy ]

  # GET /roles or /roles.json
  def index
    @roles = Role.where.not(nombre: "admin")
  end

  # GET /roles/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "roles", "crear")

    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "roles", "actualizar")
  end

  # POST /roles or /roles.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "roles", "crear")

    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        ActionCable.server.broadcast("admins", "Se ha creado un role, con id "+ @role.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un role, con id "+ @role.id.to_s)

        format.html { redirect_to roles_url, notice: "Role fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "roles", "actualizar")
    return redirect_to roles_path, alert: "No se pueden realizar acciones con este rol" if es_admin_role?

    respond_to do |format|
      if @role.update(role_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un role, con id "+ @role.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un role, con id "+ @role.id.to_s)

        format.html { redirect_to roles_url, notice: "Role fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "roles", "eliminar")
    return redirect_to roles_path, alert: "No se pueden realizar acciones con este rol" if es_admin_role?

    @role.destroy rescue return redirect_to roles_url, alert: "No se puede eliminar el role porque hay usuarios que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un role, con id "+ @role.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un role, con id "+ @role.id.to_s)

      format.html { redirect_to roles_url, notice: "Role fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.require(:role).permit(:nombre, :descripcion)
    end

    def es_admin_role? 
        @role.nombre == "admin"
    end
end
