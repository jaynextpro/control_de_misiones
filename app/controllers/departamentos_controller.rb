class DepartamentosController < ApplicationController
    before_action :authenticate_usuario!
  before_action :set_departamento, only: %i[ show edit update destroy ]

  # GET /departamentos or /departamentos.json
  def index
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_modulo?(current_usuario, "departamentos")

    @departamentos = Departamento.all
  end

  # GET /departamentos/new
  def new
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "departamentos", "crear")

    @departamento = Departamento.new
  end

  # GET /departamentos/1/edit
  def edit
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "departamentos", "actualizar")
  end

  # POST /departamentos or /departamentos.json
  def create
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "departamentos", "crear")

    @departamento = Departamento.new(departamento_params)

    respond_to do |format|
      if @departamento.save
        ActionCable.server.broadcast("admins", "Se ha creado un departamento, con id "+ @departamento.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha creado un departamento, con id "+ @departamento.id.to_s)

        format.html { redirect_to departamentos_url, notice: "Departamento fue creado satisfactoriamente" }
        format.json { render :show, status: :created, location: @departamento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departamentos/1 or /departamentos/1.json
  def update
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "departamentos", "actualizar")

    respond_to do |format|
      if @departamento.update(departamento_params)
        ActionCable.server.broadcast("admins", "Se ha actualizado un departamento, con id "+ @departamento.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha actualizado un departamento, con id "+ @departamento.id.to_s)

        format.html { redirect_to departamentos_url, notice: "Departamento fue actualizado satisfactoriamente" }
        format.json { render :show, status: :ok, location: @departamento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departamentos/1 or /departamentos/1.json
  def destroy
    return redirect_to "/", alert: "No tienes permisos suficientes" unless acceso_a_accion_de_modulo?(current_usuario, "departamentos", "eliminar")

    @departamento.destroy rescue return redirect_to departamentos_url, alert: "No se puede eliminar el departamento porque hay empleados que dependen de el"

    respond_to do |format|
      ActionCable.server.broadcast("admins", "Se ha eliminado un departamento, con id "+ @departamento.id.to_s) if LogActividade.create(usuario_id: current_usuario.id, actividad: "Se ha eliminado un departamento, con id "+ @departamento.id.to_s)

      format.html { redirect_to departamentos_url, notice: "Departamento fue eliminado satisfactoriamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departamento
      @departamento = Departamento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def departamento_params
      params.require(:departamento).permit(:nombre)
    end
end
