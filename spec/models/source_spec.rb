require 'rails_helper'

RSpec.describe Source, type: :model do
  subject { create(:source) }

  describe '#name' do
    it 'is required' do
      expect(build(:source, name: nil)).not_to be_valid
    end

    it 'most be unique' do
      expect(build(:source, name: subject.name)).not_to be_valid
    end
  end
end

# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sources_on_name  (name) UNIQUE
#
