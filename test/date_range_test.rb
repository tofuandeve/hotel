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

    describe "overlap? method" do
        before do
            start_date = '2019-09-10'
            end_date = '2019-09-13'
            @date = Hotel::DateRange.new(start_date, end_date)
        end

        it "returns true if 2 date ranges overlap" do
            start_date1 = '2019-09-09'
            end_date1 = '2019-09-15'
            date1 = Hotel::DateRange.new(start_date1, end_date1)

            start_date2 = '2019-09-11'
            end_date2 = '2019-09-12'
            date2 = Hotel::DateRange.new(start_date2, end_date2)

            start_date3 = '2019-09-12'
            end_date3 = '2019-09-19'
            date3 = Hotel::DateRange.new(start_date3, end_date3)

            expect (@date.overlap?(date1)).must_equal true
            expect (@date.overlap?(date2)).must_equal true
            expect (@date.overlap?(date3)).must_equal true
        end

        it "returns false if 2 date ranges don't overlap" do
            start_date1 = '2019-09-09'
            end_date1 = '2019-09-10'
            date1 = Hotel::DateRange.new(start_date1, end_date1)

            start_date2 = '2019-09-13'
            end_date2 = '2019-09-19'
            date2 = Hotel::DateRange.new(start_date2, end_date2)

            start_date3 = '2019-09-20'
            end_date3 = '2019-09-25'
            date3 = Hotel::DateRange.new(start_date3, end_date3)

            expect (@date.overlap?(date1)).must_equal false
            expect (@date.overlap?(date2)).must_equal false
            expect (@date.overlap?(date3)).must_equal false
        end
    end
end