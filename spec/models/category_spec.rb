require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { create(:category) }

  describe '#name' do
    it 'is required' do
      expect(build(:category, name: nil)).not_to be_valid
    end

    it 'most be unique' do
      expect(build(:category, name: subject.name)).not_to be_valid
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
