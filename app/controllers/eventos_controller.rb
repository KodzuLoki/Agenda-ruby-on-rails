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

  def por_usuario
    # Encuentra al usuario por su ID
    @usuario = Usuario.find(params[:id])

    # Obtén todos los eventos del usuario
    @eventos = @usuario.eventos

    # Renderiza la vista correspondiente
    respond_to do |format|
      format.html # por_usuario.html.erb
    end
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

  # Crear un evento y enviar notificación por correo electrónico
  def create
    @evento = Evento.new(evento_params)
    
    if Evento.usuario_ocupado?(@evento.usuario_id, @evento.fecha)
      redirect_to new_evento_path, alert: 'El usuario ya tiene un evento en la fecha y hora seleccionadas.'
    elsif @evento.save
      # Enviar notificación por correo al usuario vinculado y al correo del administrador
      enviar_notificacion_por_correo(@evento)

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
    respond_to do |format|
      format.html { redirect_to eventos_url, notice: 'El evento fue eliminado con éxito.' }
      format.json { head :no_content }
    end
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
    return { error: 'Ciudad no especificada' } if ciudad.blank?

    clima = OpenWeatherService.consultar_clima(ciudad)
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

  # Método para enviar la notificación por correo utilizando SendGrid
  def enviar_notificacion_por_correo(evento)
    # Definir el correo del administrador
    correo_admin = 'elioth.bass@gmail.com'

    # Enviar correo al usuario vinculado con el evento
    if evento.usuario
      SendgridService.enviar_notificacion(evento, evento.usuario.email)
    end

    # Enviar correo al administrador
    SendgridService.enviar_notificacion(evento, correo_admin)
  end
end
