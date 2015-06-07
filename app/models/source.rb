# The source of a 311 case. For example "Voice In" or "Web Self Service".
class Source < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  has_many :sf311_cases, inverse_of: :source
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
