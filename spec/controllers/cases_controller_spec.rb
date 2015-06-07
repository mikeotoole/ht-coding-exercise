require 'rails_helper'

RSpec.describe CasesController, type: :controller do
  let!(:cases) do
    [old_case, new_case, closed_case, open_case, close_case1, close_case2]
  end
  let(:time) { Time.zone.now }
  let(:old_case) { create(:sf311_case, opened_at: time - 1.day) }
  let(:new_case) { create(:sf311_case, opened_at: time + 1.day) }
  let(:closed_case) { create(:sf311_case, :closed) }
  let(:open_case) { create(:sf311_case, :opened) }
  let(:close_case1) do
    create(:sf311_case, category: new_case.category,
                        opened_at: new_case.opened_at,
                        latitude: 37.90,
                        longitude: -122.50)
  end
  let(:close_case2) do
    create(:sf311_case, category: new_case.category,
                        latitude: 37.90,
                        longitude: -122.51)
  end
  let(:params) { { format: :json } }
  let(:parsed_body) { JSON.parse(response.body) }
  let(:returned_case_ids) { parsed_body['data'].map { |h| h['case_id'] } }

  describe 'GET #index' do
    before(:each) { get :index, params }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns expected case hash' do
      expected_hash = {
        'address' => old_case.address,
        'case_id' => old_case.case_id,
        'category' => old_case.category_name,
        'latitude' => old_case.latitude.to_s,
        'longitude' => old_case.longitude.to_s,
        'neighborhood' => old_case.neighborhood,
        'opened' => old_case.opened_at.to_s,
        'request_type' => old_case.request_type,
        'responsible_agency' => old_case.responsible_agency,
        'source' => old_case.source_name,
        'status' => old_case.status,
        'supervisor_district' => old_case.supervisor_district,
        'updated' => old_case.last_updated_at.to_s
      }
      expect(parsed_body['data'].first).to eq expected_hash
    end

    context 'when given negative page number' do
      let(:params) { { format: :json, page: -2 } }

      it 'returns error code and errors' do
        expect(response).to have_http_status(:bad_request)
        expect(parsed_body['errors'].first)
          .to match(/invalid page number.*/i)
      end
    end

    context 'when given no filter params' do
      it 'returns all cases' do
        expect(parsed_body['data'].count).to eq cases.count
      end
    end

    context 'when given since filter' do
      let(:params) { { format: :json, since: time.to_i.to_s } }

      it 'returns cases opened since UNIX timestamp' do
        expect(returned_case_ids).to eq [new_case.case_id, close_case1.case_id]
      end

      context 'that is invalid' do
        let(:params) { { format: :json, since: '2015-01-01' } }

        it 'returns error code and errors' do
          expect(response).to have_http_status(:bad_request)
          expect(parsed_body['errors'].first)
            .to match(/param since is invalid.*/i)
        end
      end
    end

    context 'when given status filter' do
      let(:params) { { format: :json, status: 'closed' } }

      it 'returns cases that are in given state' do
        expect(returned_case_ids).to eq [closed_case.case_id]
      end

      context 'that is invalid' do
        let(:params) { { format: :json, status: 'bad' } }

        it 'returns error code and errors' do
          expect(response).to have_http_status(:bad_request)
          expect(parsed_body['errors'].first)
            .to match(/param status is invalid.*/i)
        end
      end
    end

    context 'when given category filter' do
      it 'returns cases that are in the category with given name' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when given near filter' do
      let(:params) do
        { format: :json, near: '37.87,-122.49' }
      end

      it 'returns cases that within 5 mile radius of lat and lon' do
        expect(returned_case_ids)
          .to eq [close_case1.case_id, close_case2.case_id]
      end

      context 'that is invalid' do
        let(:params) { { format: :json, near: '37.7898293' } }

        it 'returns error code and errors' do
          expect(response).to have_http_status(:bad_request)
          expect(parsed_body['errors'].first)
            .to match(/param near is invalid.*/i)
        end
      end
    end

    context 'when given near, status, and category filters' do
      let(:params) do
        {
          format: :json,
          near: '37.77,-122.43',
          status: 'open',
          category: URI.encode(new_case.category_name)
        }
      end

      it 'returns cases matching all params' do
        expect(returned_case_ids).to eq [new_case.case_id]
      end
    end
  end
end
