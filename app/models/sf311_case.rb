# San Francisco 311 Case
class Sf311Case < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  VALID_STATUS = %w(closed open).freeze

  belongs_to :category, inverse_of: :sf311_cases
  belongs_to :source, inverse_of: :sf311_cases

  validates :category, :source, presence: true
  validates :address, :request_type, :last_updated_at, :neighborhood,
            :responsible_agency, :opened_at, presence: true
  validates :case_id, numericality: { only_integer: true },
                      uniqueness: true,
                      presence: true
  validates :supervisor_district, numericality: { only_integer: true },
                                  presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90,
                                       less_than_or_equal_to: 90 },
                       presence: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180,
                                        less_than_or_equal_to: 180 },
                        presence: true

  delegate :name, to: :category, prefix: true
  delegate :name, to: :source, prefix: true

  scope :since, lambda { |since_time|
    where('opened_at >= ?', since_time) if since_time
  }

  scope :category_name, lambda { |category_name|
    if category_name.is_a?(String)
      includes(:category)
        .where(categories: { name: URI.decode(category_name) })
    end
  }

  scope :status, lambda { |status|
    case status.try(:downcase)
    when 'open'
      where(closed_at: nil)
    when 'closed'
      where.not(closed_at: nil)
    end
  }

  scope :filter_by, lambda { |filters|
    base = since(filters[:since_time])
           .category_name(filters[:category])
    if filters[:near_array]
      base = base.near(filters[:near_array], filters[:near_distance])
    end
    base.status(filters[:status])
  }

  def status
    closed_at ? 'Closed' : 'Open'
  end
end

# == Schema Information
#
# Table name: sf311_cases
#
#  id                  :integer          not null, primary key
#  category_id         :integer          not null
#  source_id           :integer          not null
#  request_details     :string(255)
#  address             :string(255)      not null
#  request_type        :string(255)      not null
#  last_updated_at     :datetime         not null
#  neighborhood        :string(255)      not null
#  case_id             :integer          not null
#  closed_at           :datetime
#  supervisor_district :integer          not null
#  responsible_agency  :string(255)      not null
#  opened_at           :datetime         not null
#  latitude            :decimal(16, 13)  not null
#  longitude           :decimal(16, 13)  not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_sf311_cases_on_case_id      (case_id) UNIQUE
#  index_sf311_cases_on_category_id  (category_id)
#  index_sf311_cases_on_closed_at    (closed_at)
#  index_sf311_cases_on_latitude     (latitude)
#  index_sf311_cases_on_longitude    (longitude)
#  index_sf311_cases_on_opened_at    (opened_at)
#  index_sf311_cases_on_source_id    (source_id)
#
