ActionMailer::Base.smtp_settings = {
  domain: 'https://segunda-mao-carrefour.herokuapp.com/',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name: 'apikey',
  password: Rails.application.credentials.sendgrid[:api_key],
}