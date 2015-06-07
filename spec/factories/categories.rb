FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Illegal Postings#{n == 1 ? '' : '' + n.to_s}" }
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
