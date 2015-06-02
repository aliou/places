require 'rails_helper'

describe ApplicationHelper do
  describe '#basscss_class_for_alert' do
    it 'returns the classes' do
      expect(basscss_class_for_alert('success')).to eq('bg-green white')
      expect(basscss_class_for_alert('error')).to eq('bg-red white')
      expect(basscss_class_for_alert('alert')).to eq('bg-yellow')
      expect(basscss_class_for_alert('notice')).to eq('bg-blue white')
      expect(basscss_class_for_alert).to eq('bg-blue white')
    end
  end
end
