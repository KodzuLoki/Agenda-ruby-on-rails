# app/controllers/eventos_controller.rb
class EventosController < ApplicationController
    before_action :set_evento, only: [:show, :edit, :update, :destroy]
  
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
  
    def create
      @evento = Evento.new(evento_params)
      if @evento.save
        redirect_to @evento, notice: 'Evento creado exitosamente.'
      else
        render :new
      end
    end
  
    # Mostrar detalles de un evento en particular
    def show
    end
  
    # Editar un evento existente
    def edit
    end
  
    def update
      if @evento.update(evento_params)
        redirect_to @evento, notice: 'Evento actualizado exitosamente.'
      else
        render :edit
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
  
    def set_evento
      @evento = Evento.find(params[:id])
    end
  
    def evento_params
      params.require(:evento).permit(:titulo, :descripcion, :fecha, :usuario_id)
    end
  end
  