# The category of a 311 case. For example "General Requests" or
# "Illegal Postings".
class Category < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  has_many :sf311_cases, inverse_of: :category
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
