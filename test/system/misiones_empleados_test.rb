require "application_system_test_case"

class MisionesEmpleadosTest < ApplicationSystemTestCase
  setup do
    @misiones_empleado = misiones_empleados(:one)
  end

  test "visiting the index" do
    visit misiones_empleados_url
    assert_selector "h1", text: "Misiones Empleados"
  end

  test "creating a Misiones empleado" do
    visit misiones_empleados_url
    click_on "New Misiones Empleado"

    fill_in "Empleado", with: @misiones_empleado.empleado_id
    fill_in "Misione", with: @misiones_empleado.misione_id
    click_on "Create Misiones empleado"

    assert_text "Misiones empleado was successfully created"
    click_on "Back"
  end

  test "updating a Misiones empleado" do
    visit misiones_empleados_url
    click_on "Edit", match: :first

    fill_in "Empleado", with: @misiones_empleado.empleado_id
    fill_in "Misione", with: @misiones_empleado.misione_id
    click_on "Update Misiones empleado"

    assert_text "Misiones empleado was successfully updated"
    click_on "Back"
  end

  test "destroying a Misiones empleado" do
    visit misiones_empleados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Misiones empleado was successfully destroyed"
  end
end
