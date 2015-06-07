json.call(sf311_case, :case_id, :address, :request_type,
          :neighborhood, :status, :supervisor_district, :responsible_agency,
          :latitude, :longitude)
json.request_details sf311_case.request_details if sf311_case.request_details
json.category sf311_case.category_name
json.source sf311_case.source_name
json.opened sf311_case.opened_at.to_s
json.updated sf311_case.last_updated_at.to_s
