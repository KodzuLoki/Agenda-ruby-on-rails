# app/models/evento.rb

# La clase Evento representa un evento en la agenda de la aplicación.
# Hereda de ApplicationRecord para interactuar con la base de datos (uso actual en Rails).
class Evento < ApplicationRecord
  # Relación con el modelo Usuario.
  # Un evento pertenece a un usuario específico.
  belongs_to :usuario

  # Validaciones para asegurar que el evento tenga la información requerida.
  validates :titulo, presence: true
  validates :descripcion, presence: true
  validates :fecha, presence: true
  validates :usuario_id, presence: true

  # Validación personalizada para evitar superposición de eventos en la misma fecha y hora.
  validate :no_superposicion_de_eventos

  # Método de clase para verificar si un usuario está ocupado en una fecha/hora dada.
  # Retorna verdadero si existe un evento para el usuario en la fecha proporcionada.
  def self.usuario_ocupado?(usuario_id, fecha)
    where(usuario_id: usuario_id).where(fecha: fecha).exists?
  end

  # Método para obtener la información del clima para la fecha y ciudad del evento.
  # Si no se especifica una ciudad, se usa una ciudad predeterminada.
  def obtener_clima
    ciudad = self.ciudad || 'Santiago' # Ciudad por defecto si no se especifica.
    OpenWeatherService.consultar_clima(ciudad)
  end

  private

  # Validación para asegurarse de que no se creen eventos en la misma fecha y hora para el mismo usuario.
  def no_superposicion_de_eventos
    # Buscar eventos del mismo usuario que coincidan en fecha y hora.
    eventos_superpuestos = Evento.where(usuario_id: usuario_id, fecha: fecha)

    # Si se encuentra algún evento, agregar un error.
    if eventos_superpuestos.exists?
      errors.add(:fecha, 'El usuario ya tiene un evento programado en esta fecha y hora.')
    end
  end
end
