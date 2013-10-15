class Rate < ActiveRecord::Base
  validates_presence_of  :rate, :term
  
  validates_length_of :rate, 
                      :maximum => 7, #000.00%
                      :message => "Rate value is too long."

  validates_format_of :rate, 
                      :with => /^\d+(\.\d{1,2})?%/,
                      :message => "Examples: 23% or 25.01% (Percentage sign is mandatory)"

  def validate
    rate = Rate.default_calculator_rate
    
    # Make sure we have only one default calculator rate
    if is_default_calculator_rate
      rate.toggle!(:is_default_calculator_rate) if rate
    # Make sure we have at least one default calculator rate
    else
      errors.add_to_base('You need to have one default calculator rate') if rate && rate.id == id
    end
  end
  
  class << self
    def default_calculator_rate
      find(:first, :conditions => "is_default_calculator_rate = 1")
    end
  end  
end