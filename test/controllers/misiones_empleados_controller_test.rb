require "test_helper"

class MisionesEmpleadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @misiones_empleado = misiones_empleados(:one)
  end

  test "should get index" do
    get misiones_empleados_url
    assert_response :success
  end

  test "should get new" do
    get new_misiones_empleado_url
    assert_response :success
  end

  test "should create misiones_empleado" do
    assert_difference('MisionesEmpleado.count') do
      post misiones_empleados_url, params: { misiones_empleado: { empleado_id: @misiones_empleado.empleado_id, misione_id: @misiones_empleado.misione_id } }
    end

    assert_redirected_to misiones_empleado_url(MisionesEmpleado.last)
  end

  test "should show misiones_empleado" do
    get misiones_empleado_url(@misiones_empleado)
    assert_response :success
  end

  test "should get edit" do
    get edit_misiones_empleado_url(@misiones_empleado)
    assert_response :success
  end

  test "should update misiones_empleado" do
    patch misiones_empleado_url(@misiones_empleado), params: { misiones_empleado: { empleado_id: @misiones_empleado.empleado_id, misione_id: @misiones_empleado.misione_id } }
    assert_redirected_to misiones_empleado_url(@misiones_empleado)
  end

  test "should destroy misiones_empleado" do
    assert_difference('MisionesEmpleado.count', -1) do
      delete misiones_empleado_url(@misiones_empleado)
    end

    assert_redirected_to misiones_empleados_url
  end
end
