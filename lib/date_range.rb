require 'date'

module Hotel
  class DateRange
    attr_reader :start_date, :end_date
    
    def initialize(input_start_date, input_end_date)
      @start_date = input_start_date
      @end_date = input_end_date
      current_time = Date.today()
      
      if (@start_date < current_time) || 
        (@end_date < current_time) || 
        (@end_date <= @start_date)
        raise ArgumentError.new("Invalid date input: Check-in: #{input_start_date}, check_out: #{input_end_date}")
      end 
    end
    
    def overlap?(date_range)
      return @start_date < date_range.end_date && @end_date > date_range.start_date
    end
  end
end