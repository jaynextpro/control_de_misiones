Rails.application.routes.draw do
  resources :log_actividades, only: [:index]
  resources :misiones_empleados do 
    get "generar_reporte", to: "misiones_empleados#generar_reporte", on: :collection, as: :generar_reporte
  end
  resources :misiones
  resources :empleados
  resources :departamentos
  resources :cargos
  resources :permisos
  resources :modulos
  resources :roles
  devise_for :usuarios
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :usuario do
    authenticated :usuario do
      root 'home#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :usuarios
end
