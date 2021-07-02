# 2ª MÃO POINT CARREFOUR
A aplicação foi desenvolvida durante o curso do Le Wagon, em Junho/2021, utilizando Ruby on Rails. O site em produção está publicado no heroku e visível pelo link: http://segunda-mao-carrefour.herokuapp.com.

## Tecnologia utilizada
O site foi desenvolvido com Ruby on Rails (6.1.0) e Ruby (3.0.1). Gems e plugins utilizados:

- Autenticação: Devise
- Autorização: Pundit
- Geolocalização: Geocoder, Mapbox
- Envio de mensagens de Whatsapp: Twilio, Phonelib
- Alertas: SweetAlert2
- Estilo: Bootstrap
- Formulários: Wicked, SimpleForm, JS-Mask, Flatpickr
- Testes: Rspec, Capybara, Factory Bot
- Seeds: Faker
- QR Code: RQRCode
- Background jobs: Sidekiq, Redis
- Produção: Heroku

## Rake tasks
- `rake trades:clean` para limpar agendamentos não concluídos
