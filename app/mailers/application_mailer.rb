class ApplicationMailer < ActionMailer::Base
  # Change default email !
  CONTACT_MAIL = '2mao.carrefour@gmail.com'
  default from: CONTACT_MAIL
  layout 'mailer'
end
