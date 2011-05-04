require 'active_model'

class BatchTranslationRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActionView::Helpers::NumberHelper
  extend ActiveModel::Naming

  validates_presence_of :file, :language
  validate :validate_max_file_size

  attr_accessor :file, :filename, :language

  def initialize(file, language)
    if file then
      @filename = file.original_filename
      @file = file.tempfile
      @language = language
    else
      nil
    end
  end

  def validate_max_file_size

    #ActiveRecord::Base.logger.debug("file path: #{@file.path}")

    limit = 200.kilobyte
    errors.add(:file, "can't be greater than #{number_to_human_size(limit)}") if !@file.blank? and @file.size > limit
  end

end

