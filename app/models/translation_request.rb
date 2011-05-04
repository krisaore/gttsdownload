require 'active_model'

class TranslationRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validates_presence_of :language, :text
  validates_length_of :text, :maximum => 500

  attr_accessor :language, :text

  def initialize(language, text)
    @language, @text = language, text
  end

end

