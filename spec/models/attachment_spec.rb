require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :place }
  it { should validate_presence_of :url }
end
