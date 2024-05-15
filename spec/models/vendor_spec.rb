require 'rails_helper'

RSpec.describe Vendor, type: :model do
  it { should have_many :markets }
end
