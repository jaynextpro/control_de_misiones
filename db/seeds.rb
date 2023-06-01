# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Role.create!(nombre: "admin")
Role.create!(nombre: "test")

Usuario.create!(email: "javier@controldemisiones.com", password: "Osama123$", password_confirmation: "Osama123$", role_id: Role.find_by(nombre: "admin").id)
Usuario.create!(email: "javier2@controldemisiones.com", password: "Osama123$", password_confirmation: "Osama123$", role_id: Role.second.id)

Cargo.create(nombre: "Manager de misiones")
Cargo.create(nombre: "Colaborador de administracion")

Departamento.create(nombre: "Administracion")
Departamento.create(nombre: "Misiones")

Modulo.create!([{nombre: "usuarios"}, {nombre: "empleados"}, {nombre: "departamentos"}, {nombre: "cargos"}, {nombre: "roles"}, {nombre: "misiones"}, {nombre: "misiones_empleados"}, {nombre: "permisos"}])
