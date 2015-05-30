require 'rails_helper'

describe MapHelper do
  describe '#zoom_to_radius' do
  end

  describe '#degrees_to_radians' do
    it { expect(degrees_to_radians(0)).to eq(0) }
    it { expect(degrees_to_radians(90)).to eq(Math::PI / 2) }
    it { expect(degrees_to_radians(180)).to eq(Math::PI) }
    it { expect(degrees_to_radians(270)).to eq(Math::PI * 3 / 2) }
    it { expect(degrees_to_radians(360)).to eq(Math::PI * 2) }
  end
end
