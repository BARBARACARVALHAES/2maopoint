# 2ª MÃO POINT CARREFOUR
A aplicação foi desenvolvida durante uma parceria entre Le Wagon e o Banco Carrefour, em Junho/2021, utilizando Ruby on Rails. O site em produção está publicado no heroku e visível pelo link: http://segunda-mao-carrefour.herokuapp.com.

## O Stack
O site foi desenvolvido com Ruby on Rails (6.1.0) e Ruby (3.0.1). O stack é:
- Autenticação: Devise
- Autorização: Pundit
- Geolocalização: Geocoder, Mapbox
- Envio de mensagens de Whatsapp: Twilio
- Alertas: SweetAlert2
- Estilo: Bootstrap
- Formulários: Wicked, SimpleForm, JS-Mask, Flatpickr
- Testes: Rspec, Capybara, Factory Bot
- Seeds: Faker
- QR Code: RQRCode
- Background jobs: Sidekiq, Redis
- Produção: Heroku

## Desenvolvimento local
Se você não tem, deve instalar:
- ruby 3.0.1 `rbenv install 3.0.1` && `rbenv global 3.0.1`
- NodeJS (version 14.15, you may use nvm if you have several versions)
- yarn `npm i -g yarn`

Não esqueça de executar `bundle install` e `yarn install` antes de rodar o servidor local `rails s` pela primeira vez.

## Instale Redis e PostgreSQL:
Instale redis & postgresql diretamente na sua máquina, por exemplo, com `brew install redis && brew install postgresql` no macOS.

## Testes
Para executar testes localmente, use `rspec`. Se não funcionar, tente `bundle exec rspec`.

## Rake tasks
- `rake trades:clean` para limpar agendamentos não concluídos
