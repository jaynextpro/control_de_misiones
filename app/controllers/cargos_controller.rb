class CargosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_cargo, only: %i[ show edit update destroy ]

  # GET /cargos or /cargos.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "cargos")
    @cargos = Cargo.all
  end

  # GET /cargos/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "cargos", "crear")

    @cargo = Cargo.new
  end

  # GET /cargos/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "cargos", "actualizar")
  end

  # POST /cargos or /cargos.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "cargos", "crear")

    @cargo = Cargo.new(cargo_params)

    respond_to do |format|
      if @cargo.save
        ActionCable.server.broadcast("admins", "Se ha creado un cargo, con id "+ @cargo.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un cargo, con id "+ @cargo.id.to_s)

        format.html { redirect_to cargos_url, notice: "Cargo fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @cargo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cargos/1 or /cargos/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "cargos", "actualizar")

    respond_to do |format|
      if @cargo.update(cargo_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un cargo, con id "+ @cargo.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un cargo, con id "+ @cargo.id.to_s)

        format.html { redirect_to cargos_url, notice: "Cargo fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @cargo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cargos/1 or /cargos/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "cargos", "eliminar")

    @cargo.destroy rescue return redirect_to cargos_url, alert: "No se puede eliminar el cargo porque hay empleados que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un cargo, con id "+ @cargo.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un cargo, con id "+ @cargo.id.to_s)

      format.html { redirect_to cargos_url, notice: "Cargo fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cargo_params
      params.require(:cargo).permit(:nombre)
    end
end
