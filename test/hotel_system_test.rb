require_relative 'test_helper'

describe Hotel::HotelSystem do
    describe "Constructor" do
        it "can instantiate a HotelSystem object" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system).must_be_instance_of Hotel::HotelSystem
        end

        it "can instantiate a HotelSystem that tracks 20 rooms" do
            expected_number_of_rooms = 20
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.number_of_rooms).must_equal expected_number_of_rooms
        end

        it "allows user to access a list of Reservation" do
            hotel_system = Hotel::HotelSystem.new()
            expect (hotel_system.reservations).must_be_instance_of Array
        end
    end
end