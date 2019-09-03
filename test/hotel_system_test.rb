require_relative 'test_helper'

describe "constructor" do
    it "can instantiate a HotelSystem object" do
        hotel_system = HotelSystem.new()
        expect (hotel_system).must_be_instance_of HotelSystem
    end
end