domain = Rails.env.development? ? 'http://localhost:3000/' : 'https://segunda-mao-carrefour.herokuapp.com/'

ActionMailer::Base.smtp_settings = {
  domain: domain,
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name: 'apikey',
  password: Rails.application.credentials.sendgrid[:api_key],
}