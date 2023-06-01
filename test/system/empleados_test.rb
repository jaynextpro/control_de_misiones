require "application_system_test_case"

class EmpleadosTest < ApplicationSystemTestCase
  setup do
    @empleado = empleados(:one)
  end

  test "visiting the index" do
    visit empleados_url
    assert_selector "h1", text: "Empleados"
  end

  test "creating a Empleado" do
    visit empleados_url
    click_on "New Empleado"

    fill_in "Apellidos", with: @empleado.apellidos
    fill_in "Cargo", with: @empleado.cargo_id
    fill_in "Departamento", with: @empleado.departamento_id
    fill_in "Nombres", with: @empleado.nombres
    fill_in "Numero telefono", with: @empleado.numero_telefono
    click_on "Create Empleado"

    assert_text "Empleado was successfully created"
    click_on "Back"
  end

  test "updating a Empleado" do
    visit empleados_url
    click_on "Edit", match: :first

    fill_in "Apellidos", with: @empleado.apellidos
    fill_in "Cargo", with: @empleado.cargo_id
    fill_in "Departamento", with: @empleado.departamento_id
    fill_in "Nombres", with: @empleado.nombres
    fill_in "Numero telefono", with: @empleado.numero_telefono
    click_on "Update Empleado"

    assert_text "Empleado was successfully updated"
    click_on "Back"
  end

  test "destroying a Empleado" do
    visit empleados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Empleado was successfully destroyed"
  end
end
