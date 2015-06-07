require 'rails_helper'

RSpec.describe Sf311Case, type: :model do
  subject { create(:sf311_case) }

  describe '#case_id' do
    it 'is required' do
      expect(build(:sf311_case, case_id: nil)).not_to be_valid
    end

    it 'most be unique' do
      expect(build(:sf311_case, case_id: subject.case_id)).not_to be_valid
    end
  end

  describe '#latitude' do
    it 'is required' do
      expect(build(:sf311_case, latitude: nil)).not_to be_valid
    end

    it 'most less then or equal to 90' do
      expect(build(:sf311_case, latitude: 91)).not_to be_valid
      expect(build(:sf311_case, latitude: 90)).to be_valid
    end

    it 'most greater then or equal to -90' do
      expect(build(:sf311_case, latitude: -91)).not_to be_valid
      expect(build(:sf311_case, latitude: -90)).to be_valid
    end
  end

  describe '#longitude' do
    it 'is required' do
      expect(build(:sf311_case, longitude: nil)).not_to be_valid
    end

    it 'most less then or equal to 180' do
      expect(build(:sf311_case, longitude: 181)).not_to be_valid
      expect(build(:sf311_case, longitude: 180)).to be_valid
    end

    it 'most greater then or equal to -180' do
      expect(build(:sf311_case, longitude: -181)).not_to be_valid
      expect(build(:sf311_case, longitude: -180)).to be_valid
    end
  end

  describe 'scope' do
    let(:time) { Time.zone.now }
    let!(:cases) { [old_case, new_case] }
    let(:old_case) { create(:sf311_case, opened_at: time - 1.day) }
    let(:new_case) { create(:sf311_case, opened_at: time + 1.day) }
    let(:closed_case) { create(:sf311_case, :closed) }
    let(:open_case) { create(:sf311_case, :opened) }

    describe 'since' do
      it 'only returns cases opened after given time' do
        expect(Sf311Case.since(time)).to eq [new_case]
      end

      it 'returns all cases when given nil time' do
        expect(Sf311Case.since(nil)).to eq cases
      end
    end

    describe 'category_name' do
      it 'only returns cases in category with given name' do
        expect(Sf311Case.category_name(new_case.category_name)).to eq [new_case]
      end

      it 'returns all cases when given nil name' do
        expect(Sf311Case.category_name(nil)).to eq cases
      end

      it 'works with URL encoded strings' do
        encoded_name = URI.encode(new_case.category_name)
        expect(Sf311Case.category_name(encoded_name)).to eq [new_case]
      end
    end

    describe 'status' do
      let!(:cases) { [closed_case, open_case] }

      context 'when given "closed"' do
        it 'only returns closed cases' do
          expect(Sf311Case.status('Closed')).to eq [closed_case]
        end
      end

      context 'when given "open"' do
        it 'only returns open cases' do
          expect(Sf311Case.status('Open')).to eq [open_case]
        end
      end

      it 'returns all cases when given nil status' do
        expect(Sf311Case.status(nil)).to eq cases
      end
    end

    describe 'filter_by' do
      let!(:cases) do
        [old_case, new_case, closed_case, open_case, close_case1, close_case2]
      end
      let(:close_case1) do
        create(:sf311_case, category: new_case.category,
                            opened_at: new_case.opened_at,
                            latitude: 37.7898293093397,
                            longitude: -122.403841454762)
      end
      let(:close_case2) do
        create(:sf311_case, opened_at: new_case.opened_at,
                            latitude: 37.7898293093397,
                            longitude: -122.403841454762)
      end

      context 'when given near_array filter' do
        let(:filters) do
          {
            near_array: [close_case1.latitude, close_case1.longitude],
            near_distance: 1
          }
        end

        it 'only returns cases within near_distance of point' do
          expect(Sf311Case.filter_by(filters)).to eq [close_case1, close_case2]
        end
      end

      context 'when given all filters' do
        let(:filters) do
          {
            near_array: [close_case1.latitude, close_case1.longitude],
            near_distance: 1,
            since_time: time,
            category: close_case1.category_name,
            status: 'Open'
          }
        end

        it 'only returns cases matching all filters' do
          expect(Sf311Case.filter_by(filters)).to eq [close_case1]
        end
      end

      it 'returns all cases when given empty filter hash' do
        expect(Sf311Case.filter_by({})).to eq cases
      end
    end
  end

  describe '#status' do
    context 'when closed_at is nil' do
      subject { build(:sf311_case, :closed) }

      it 'returns "Closed"' do
        expect(subject.status).to eq 'Closed'
      end
    end

    context 'when closed_at is not nil' do
      subject { build(:sf311_case, :opened) }

      it 'returns "Open"' do
        expect(subject.status).to eq 'Open'
      end
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
