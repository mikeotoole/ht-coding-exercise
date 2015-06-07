require 'rails_helper'
require 'sf311/importer'

RSpec.describe Sf311::Importer, type: :model do
  let(:import) do
    VCR.use_cassette('sf311/api/get_small') do
      Sf311::Importer.new.import!
    end
  end
  let(:sf311_case) { create(:sf311_case, :opened, case_id: '4803331') }

  describe '#import!' do
    it 'imports all cases on first run' do
      VCR.use_cassette('sf311/api/get') do
        expect(Sf311::Importer.new.import!).to eq 1000
      end
      expect(Sf311Case.count).to eq 1000
    end

    it 'creates new cases as expected' do
      import
      sf_case = Sf311Case.find_by_case_id('4803331')
      expect(sf_case.category_name).to eq 'Illegal Postings'
      expect(sf_case.source_name).to eq 'Voice In'
      expect(sf_case.address).to eq '1035 HAIGHT ST, SAN FRANCISCO, CA, 94117'
      expect(sf_case.request_type).to eq 'Illegal Postings - Multiple_Postings'
      expect(sf_case.request_details).to eq 'Multiple_Postings on Sidewalk'
      expect(sf_case.last_updated_at.to_s).to eq '2015-06-05 04:26:42 UTC'
      expect(sf_case.neighborhood).to eq 'Haight Ashbury'
      expect(sf_case.supervisor_district).to eq 5
      expect(sf_case.responsible_agency).to eq 'DPW BSM Queue'
      expect(sf_case.opened_at.to_s).to eq '2015-06-05 04:25:44 UTC'
      expect(sf_case.closed_at.to_s).to eq '2015-06-06 17:14:47 UTC'
      expect(sf_case.latitude).to eq 37.770874502267
      expect(sf_case.longitude).to eq(-122.439266918906)
    end

    context 'when existing cases are present' do
      it 'updates existing cases'  do
        expect(sf311_case.status).to eq 'Open'
        expect(Sf311Case.count).to eq 1
        import
        expect(Sf311Case.count).to eq 14
        expect(sf311_case.reload.status).to eq 'Closed'
      end
    end

    context 'when no cases have changed' do
      it 'returns zero' do
        expect(import).to eq 14
        VCR.use_cassette('sf311/api/get_small') do
          expect(Sf311::Importer.new.import!).to eq 0
        end
      end
    end
  end
end
