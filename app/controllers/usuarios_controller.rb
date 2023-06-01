class UsuariosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_usuario, only: %i[ edit update destroy ]

  # GET /usuarios or /usuarios.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "usuarios")
    @usuarios = Usuario.all
  end

  # GET /usuarios/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "usuarios", "crear")

    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "usuarios", "actualizar")
  end

  # POST /usuarios or /usuarios.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "usuarios", "crear")

    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        ActionCable.server.broadcast("admins", "Se ha creado un usuario, con id "+ @usuario.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un usuario, con id "+ @usuario.id.to_s)

        format.html { redirect_to usuarios_url, notice: "Usuario fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1 or /usuarios/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "usuarios", "actualizar")
    return redirect_to usuarios_path, alert: "No se pueden realizar acciones con este usuario" if es_unico_admin?

    respond_to do |format|
      if @usuario.update(usuario_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un usuario, con id "+ @usuario.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un usuario, con id "+ @usuario.id.to_s)

        format.html { redirect_to usuarios_url, notice: "Usuario fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1 or /usuarios/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "usuarios", "eliminar")
    return redirect_to usuarios_path, alert: "No se pueden realizar acciones con este usuario" if es_unico_admin?

    @usuario.destroy rescue return redirect_to usuarios_url, alert: "No se puede eliminar el usuario porque hay usuarios o asignaciones a misiones que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un usuario, con id "+ @usuario.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un usuario, con id "+ @usuario.id.to_s)

      format.html { redirect_to usuarios_url, notice: "Usuario fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      params.require(:usuario).permit(:empleado_id, :role_id, :email, :password, :password_confirmation)
    end

    def es_unico_admin? 
        @usuario.role.nombre == "admin" && Usuario.joins(:role).where("roles.nombre = 'admin'").count == 1
    end
end
