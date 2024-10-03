# config/initializers/sendgrid.rb

# Este archivo inicializa la configuración de SendGrid para tu aplicación Rails

ActionMailer::Base.smtp_settings = {
  address:              'smtp.sendgrid.net',
  port:                 587,
  domain:               'example.com',
  user_name:            'apikey',
  password:             ENV['SENDGRID_API_KEY'], # Usa variables de entorno para mayor seguridad
  authentication:       :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
