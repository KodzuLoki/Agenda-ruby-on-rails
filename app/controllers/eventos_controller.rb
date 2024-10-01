# app/controllers/eventos_controller.rb
class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_action :set_clima, only: [:show]

  # Mostrar todos los eventos en orden cronológico
  def index
    @eventos = Evento.order(:fecha)
  end

  # Mostrar eventos de un trabajador en particular
  def agenda_usuario
    @usuario = Usuario.find(params[:usuario_id])
    @eventos = @usuario.eventos.order(:fecha)
  end

  # Verificar si un usuario está ocupado en una fecha/hora
  def verificar_disponibilidad
    ocupado = Evento.usuario_ocupado?(params[:usuario_id], params[:fecha])
    render json: { usuario_ocupado: ocupado }
  end

  # Crear un nuevo evento
  def new
    @evento = Evento.new
  end

  # Crear un evento y verificar la disponibilidad antes de guardarlo
  def create
    @evento = Evento.new(evento_params)
    
    # Verificar disponibilidad antes de crear el evento
    if Evento.usuario_ocupado?(@evento.usuario_id, @evento.fecha)
      redirect_to new_evento_path, alert: 'El usuario ya tiene un evento en la fecha y hora seleccionadas.'
    elsif @evento.save
      redirect_to @evento, notice: 'Evento creado exitosamente.'
    else
      render :new, alert: "No se pudo crear el evento: #{@evento.errors.full_messages.join(', ')}"
    end
  end

  # Mostrar detalles de un evento en particular
  def show
  end

  # Editar un evento existente
  def edit
  end

  # Actualizar un evento y verificar la disponibilidad antes de guardarlo
  def update
    # Verificar si el nuevo horario interfiere con otros eventos del usuario
    if Evento.usuario_ocupado?(@evento.usuario_id, @evento.fecha)
      redirect_to edit_evento_path(@evento), alert: 'El usuario ya tiene un evento en la fecha y hora seleccionadas.'
    elsif @evento.update(evento_params)
      redirect_to @evento, notice: 'Evento actualizado exitosamente.'
    else
      render :edit, alert: "No se pudo actualizar el evento: #{@evento.errors.full_messages.join(', ')}"
    end
  end

  # Eliminar un evento
  def destroy
    @evento.destroy
    redirect_to eventos_url, notice: 'Evento eliminado exitosamente.'
  end

  # Acceso a la información en formato JSON
  def eventos_json
    @eventos = Evento.all
    render json: @eventos
  end

  private

  # Asignar el evento actual a @evento
  def set_evento
    @evento = Evento.find(params[:id])
  end

  # Asignar la información del clima al evento actual usando OpenWeatherService
  def set_clima
    @clima = obtener_clima(@evento.ciudad)
  end

  # Parámetros permitidos para la creación/edición de eventos
  def evento_params
    params.require(:evento).permit(:titulo, :descripcion, :fecha, :ciudad, :usuario_id)
  end

  # Método para obtener el clima de la ciudad del evento
  def obtener_clima(ciudad)
    # Asegurar que la ciudad está presente para consultar el clima
    return { error: 'Ciudad no especificada' } if ciudad.blank?

    # Llamar al servicio de OpenWeather para obtener el clima
    clima = OpenWeatherService.consultar_clima(ciudad)

    # Validar que la respuesta del servicio sea exitosa
    if clima.is_a?(Hash) && clima['main'] && clima['weather']
      {
        temperatura: clima['main']['temp'],
        descripcion: clima['weather'].first['description'],
        icono: clima['weather'].first['icon']
      }
    else
      { error: clima['error'] || 'No se pudo obtener el clima para la ciudad especificada.' }
    end
  end
end
