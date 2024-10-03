# app/mailers/test_mailer.rb
class TestMailer < ApplicationMailer
    default from: 'elioth.tatsuya@gmail.com' # correo de envío
  
    def test_email
      mail(
        to: 'elioth.bass@gmail.com', # Reemplaza con el correo de destino que quieres probar
        subject: 'Correo de Prueba',
        body: 'Este es un correo de prueba para verificar la configuración de SendGrid.',
        content_type: 'text/html'
      )
    end
  end
  