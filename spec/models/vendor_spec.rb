require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "class methods" do

  end

  describe "instance methods" do
    
  end
end
