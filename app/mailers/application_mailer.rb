class ApplicationMailer < ActionMailer::Base
  CONTACT_MAIL = '2mao_point@carrefour.com '
  default from: CONTACT_MAIL
  layout 'mailer'
end
