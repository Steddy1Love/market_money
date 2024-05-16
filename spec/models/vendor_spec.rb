require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of :contact_name }
    it { should validate_presence_of :contact_phone }
  end

  describe "class methods" do

  end

  describe "instance methods" do
    
  end
end
