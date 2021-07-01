class CepValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    regexp_cep = /^\d{5}(-?)\d{3}$/

    unless value.match?(regexp_cep)
      record.errors.add attribute, "O cep entrado não é valido"
    end
  end
end