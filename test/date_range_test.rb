require_relative 'test_helper'

describe Hotel::DateRange do
    describe "Constructor" do
        it "can construct a DateRange object" do
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            date = Hotel::DateRange.new(start_date, end_date)
            
            expect (date).must_be_instance_of Hotel::DateRange
        end
        
        it "raises ArgumentError for invalid start date and end date" do
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            
            invalid_date = '2019-09-33'
            invalid_start_date = '2019-09-23'
            invalid_end_date = '2019-09-07'
            invalid_past_date = '2019-09-01'
            
            expect {Hotel::DateRange.new(invalid_date, invalid_date)}.must_raise ArgumentError
            expect {Hotel::DateRange.new(invalid_start_date, end_date)}.must_raise ArgumentError
            expect {Hotel::DateRange.new(start_date, invalid_end_date)}.must_raise ArgumentError
            expect {Hotel::DateRange.new(invalid_past_date, end_date)}.must_raise ArgumentError
        end
    end
end