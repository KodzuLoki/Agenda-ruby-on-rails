Rails.application.routes.draw do
  resources :eventos

  get 'agenda_usuario/:usuario_id', to: 'eventos#agenda_usuario', as: :agenda_usuario
  get 'verificar_disponibilidad/:usuario_id/:fecha', to: 'eventos#verificar_disponibilidad', as: :verificar_disponibilidad
  get 'eventos_json', to: 'eventos#eventos_json', as: :eventos_json

  root 'eventos#index'
end
