class ApplicationMailer < ActionMailer::Base
  # Change default email !
  CONTACT_MAIL = 'contact@2mao.com.br'
  default from: CONTACT_MAIL
  layout 'mailer'
end
