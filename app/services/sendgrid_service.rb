# app/services/sendgrid_service.rb

class SendgridService
  include HTTParty
  base_uri 'https://api.sendgrid.com'

  def initialize
    @headers = {
      "Authorization" => "Bearer #{ENV['SENDGRID_API_KEY']}",
      "Content-Type" => "application/json"
    }
  end

  def send_email(to:, subject:, content:)
    body = {
      personalizations: [
        {
          to: [{ email: to }],
          subject: subject
        }
      ],
      from: { email: 'elioth.tatsuya@gmail.com' }, # Reemplaza con tu correo
      content: [
        {
          type: 'text/plain',
          value: content
        }
      ]
    }

    response = self.class.post('/v3/mail/send', headers: @headers, body: body.to_json)
    if response.success?
      puts "Correo enviado exitosamente"
    else
      puts "Error al enviar correo: #{response.body}"
    end
    response
  end
end
