# app/models/evento.rb

# La clase Evento representa un evento en la agenda de la aplicación.
# Hereda de ActiveRecord::Base (o ApplicationRecord en versiones modernas de Rails) para interactuar con la base de datos.
class Evento < ActiveRecord::Base
  # Definir la relación con el modelo Usuario.
  # Un evento pertenece a un usuario específico.
  belongs_to :usuario

  # Validaciones para asegurar que el evento tenga la información requerida.
  validates :titulo, presence: true
  validates :descripcion, presence: true
  validates :fecha, presence: true
  validates :usuario_id, presence: true

  # Métodos adicionales para el modelo.

  # Método de clase para verificar si un usuario está ocupado en una fecha/hora dada.
  # Retorna verdadero si existe un evento para el usuario en la fecha proporcionada.
  def self.usuario_ocupado?(usuario_id, fecha)
    where(usuario_id: usuario_id).where(fecha: fecha).exists?
  end
end
