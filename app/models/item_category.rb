class ItemCategory < ApplicationRecord
  has_many :trades

  ITEM_CATEGORIES = [
    'Para a sua casa',
    'Autos e peças',
    'Eletrônicos e celulares',
    'Músicas e hobbies',
    'Esporte e lazer',
    'Moda e beleza',
    'Agro e indústria',
    'Outra'
  ]
end
