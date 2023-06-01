class MisionesController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_misione, only: %i[ show edit update destroy ]

  # GET /misiones or /misiones.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "misiones")

    @misiones = Misione.all
  end

  # GET /misiones/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones", "crear")

    @misione = Misione.new
  end

  # GET /misiones/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones", "actualizar")
  end

  # POST /misiones or /misiones.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones", "crear")

    @misione = Misione.new(misione_params)

    respond_to do |format|
      if @misione.save
        ActionCable.server.broadcast("admins", "Se ha creado una mision, con id "+ @misione.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado una mision, con id "+ @misione.id.to_s)

        format.html { redirect_to misiones_url, notice: "Mision fue creada satisfactoriamente" }
        format.json { render :show, status: :created, location: @misione }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @misione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /misiones/1 or /misiones/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones", "actualizar")

    respond_to do |format|
      if @misione.update(misione_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado una mision, con id "+ @misione.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado una mision, con id "+ @misione.id.to_s)

        format.html { redirect_to misiones_url, notice: "Mision fue actualizada satisfactoriamente" }
        format.json { render :show, status: :ok, location: @misione }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @misione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /misiones/1 or /misiones/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "misiones", "eliminar")

    @misione.destroy rescue return redirect_to misiones_url, alert: "No se puede eliminar la mision porque hay asignaciones de usuarios a misiones que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado una mision, con id "+ @misione.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado una mision, con id "+ @misione.id.to_s)

      format.html { redirect_to misiones_url, notice: "Mision eliminada satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_misione
      @misione = Misione.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def misione_params
      params.require(:misione).permit(:nombre, :descripcion, :fecha_inicio, :fecha_final)
    end
end
