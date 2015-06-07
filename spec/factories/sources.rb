FactoryGirl.define do
  factory :source do
    sequence(:name) { |n| "Voice In#{n == 1 ? '' : '' + n.to_s}" }
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
