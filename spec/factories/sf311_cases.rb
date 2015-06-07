FactoryGirl.define do
  factory :sf311_case do
    category
    source
    address '1035 HAIGHT ST, SAN FRANCISCO, CA, 94117'
    request_type 'Illegal Postings - Multiple_Postings'
    last_updated_at '2015-06-05 15:34:39'
    neighborhood 'Haight Ashbury'
    sequence(:case_id) { |n| n }
    supervisor_district 5
    responsible_agency 'DPW BSM Queue'
    opened_at '2015-06-05 15:34:39'
    latitude 37.770874502267
    longitude(-122.439266918906)

    trait :closed do
      closed_at '2015-06-06 15:34:39'
    end

    trait :opened do
      closed_at nil
    end
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
