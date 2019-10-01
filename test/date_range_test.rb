require_relative 'test_helper'

describe Hotel::DateRange do
  before do
    @current_date = Date.today()
    @duration = 10
    
    @start_date = @current_date + 30
    @end_date = @start_date + @duration
    @date_range = Hotel::DateRange.new(@start_date, @end_date)
  end
  describe "Constructor" do
    it "can construct a DateRange object" do
      expect _(@date_range).must_be_instance_of Hotel::DateRange
    end
    
    it "raises ArgumentError for invalid start date and end date" do
      invalid_start_date = @end_date + 10
      invalid_end_date = @start_date - 10
      invalid_past_date = @current_date - 10
      
      expect {Hotel::DateRange.new(invalid_start_date, @end_date)}.must_raise ArgumentError
      expect {Hotel::DateRange.new(@start_date, invalid_end_date)}.must_raise ArgumentError
      expect {Hotel::DateRange.new(invalid_past_date, @end_date)}.must_raise ArgumentError
    end
  end
  
  describe "overlap? method" do
    it "returns true if 2 date ranges overlap" do
      start_date1 = @start_date - 1
      end_date1 = @end_date - 1
      date1 = Hotel::DateRange.new(start_date1, end_date1)
      
      start_date2 =  @start_date + 1
      end_date2 = @end_date - 1
      date2 = Hotel::DateRange.new(start_date2, end_date2)
      
      start_date3 = @start_date + 1
      end_date3 = @end_date + 1
      date3 = Hotel::DateRange.new(start_date3, end_date3)
      
      expect _(@date_range.overlap?(date1)).must_equal true
      expect _(@date_range.overlap?(date2)).must_equal true
      expect _(@date_range.overlap?(date3)).must_equal true
    end
    
    it "returns false if 2 date ranges don't overlap" do
      start_date1 = @start_date - 10
      end_date1 = start_date1 + 5
      date1 = Hotel::DateRange.new(start_date1, end_date1)
      
      start_date2 = @end_date + 5
      end_date2 = start_date2 + 5
      date2 = Hotel::DateRange.new(start_date2, end_date2)
      
      start_date3 = @start_date + 15
      end_date3 = start_date3 + 5
      date3 = Hotel::DateRange.new(start_date3, end_date3)
      
      expect _(@date_range.overlap?(date1)).must_equal false
      expect _(@date_range.overlap?(date2)).must_equal false
      expect _(@date_range.overlap?(date3)).must_equal false
    end
  end
end