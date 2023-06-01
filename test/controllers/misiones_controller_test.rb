require "test_helper"

class MisionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @misione = misiones(:one)
  end

  test "should get index" do
    get misiones_url
    assert_response :success
  end

  test "should get new" do
    get new_misione_url
    assert_response :success
  end

  test "should create misione" do
    assert_difference('Misione.count') do
      post misiones_url, params: { misione: { descripcion: @misione.descripcion, final_mision: @misione.final_mision, inicio_mision: @misione.inicio_mision, nombre: @misione.nombre } }
    end

    assert_redirected_to misione_url(Misione.last)
  end

  test "should show misione" do
    get misione_url(@misione)
    assert_response :success
  end

  test "should get edit" do
    get edit_misione_url(@misione)
    assert_response :success
  end

  test "should update misione" do
    patch misione_url(@misione), params: { misione: { descripcion: @misione.descripcion, final_mision: @misione.final_mision, inicio_mision: @misione.inicio_mision, nombre: @misione.nombre } }
    assert_redirected_to misione_url(@misione)
  end

  test "should destroy misione" do
    assert_difference('Misione.count', -1) do
      delete misione_url(@misione)
    end

    assert_redirected_to misiones_url
  end
end
