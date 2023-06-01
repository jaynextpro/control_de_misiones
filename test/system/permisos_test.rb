require "application_system_test_case"

class PermisosTest < ApplicationSystemTestCase
  setup do
    @permiso = permisos(:one)
  end

  test "visiting the index" do
    visit permisos_url
    assert_selector "h1", text: "Permisos"
  end

  test "creating a Permiso" do
    visit permisos_url
    click_on "New Permiso"

    check "Activo" if @permiso.activo
    check "Actualizar" if @permiso.actualizar
    check "Crear" if @permiso.crear
    check "Eliminar" if @permiso.eliminar
    fill_in "Modulo", with: @permiso.modulo_id
    fill_in "Role", with: @permiso.role_id
    check "Ver" if @permiso.ver
    click_on "Create Permiso"

    assert_text "Permiso was successfully created"
    click_on "Back"
  end

  test "updating a Permiso" do
    visit permisos_url
    click_on "Edit", match: :first

    check "Activo" if @permiso.activo
    check "Actualizar" if @permiso.actualizar
    check "Crear" if @permiso.crear
    check "Eliminar" if @permiso.eliminar
    fill_in "Modulo", with: @permiso.modulo_id
    fill_in "Role", with: @permiso.role_id
    check "Ver" if @permiso.ver
    click_on "Update Permiso"

    assert_text "Permiso was successfully updated"
    click_on "Back"
  end

  test "destroying a Permiso" do
    visit permisos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Permiso was successfully destroyed"
  end
end
