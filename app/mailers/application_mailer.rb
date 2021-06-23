class ApplicationMailer < ActionMailer::Base
  # Change default email !
  default from: 'contact@2mao.com.br'
  layout 'mailer'
end
