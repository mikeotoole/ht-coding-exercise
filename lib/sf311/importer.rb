require_relative 'api'

module Sf311
  # Import latest San Francisco 311 case data into the database.
  class Importer
    def import!
      # Create a map so we can track what cases we have imported and what ones
      # need to be created.
      @case_id_to_case_map = Api.cases.each_with_object({}) do |case_data, map|
        map[case_data['case_id'].to_i] = case_data
      end

      updated_count = update_existing_cases!
      created_count = create_new_cases!

      Rails.logger.info "Updated #{updated_count} and "\
                        "created #{created_count} cases."
      updated_count + created_count
    end

    private

    attr_reader :case_id_to_case_map

    CLOSED_STATUS = 'Closed'.freeze
    private_constant :CLOSED_STATUS

    # The timezone of the data is not clear. I'm just going to guess (hope) UTC.
    # If the data is in PDT and PST it would make converting to UTC tricky.
    # If the time was during the move out of DST it would be ambiguous exactly
    # what time in UTC is was.
    DATA_TIMEZONE = ActiveSupport::TimeZone['UTC'].freeze
    private_constant :DATA_TIMEZONE

    # Updates the existing Sf311Cases using the data in case_id_to_case_map.
    # When a Sf311Cases is updated its data is removed from the map.
    # This will update once opened cases to closed and also get the latest
    # case update time stamps. If any other case attributes are update
    # the case in the database will also be updated.
    def update_existing_cases!
      case_ids = case_id_to_case_map.keys
      update_count = 0
      # Currently the api only returns 1000 results. This protects us from
      # calling where(case_id: ids) for a very large number of ids if things
      # change with the API.
      case_ids.each_slice(2000) do |case_ids_batch|
        Sf311Case.where(case_id: case_ids_batch).each do |sf311_case|
          update_count += 1 if update_existing_case!(sf311_case)
        end
      end
      update_count
    end

    def update_existing_case!(sf311_case)
      # Get and remove case data from the map.
      case_data = case_id_to_case_map.delete(sf311_case.case_id)
      # To avoid touching the DB at all assign the attributes using
      # the latest case data and see if it changed.
      sf311_case.assign_attributes(hash_to_attributes(case_data))
      sf311_case.save! if sf311_case.changed?
    end

    # Creates new Sf311Cases using the data in case_id_to_case_map.
    def create_new_cases!
      case_id_to_case_map.each do |_case_id, case_data|
        Sf311Case.create!(hash_to_attributes(case_data))
      end
      case_id_to_case_map.count
    end

    def hash_to_attributes(case_data) # rubocop:disable MethodLength
      if case_data['status'] == CLOSED_STATUS
        closed_at = parse_time(case_data['closed'])
      end
      {
        category: category(case_data['category']),
        source: source(case_data['source']),
        request_details: case_data['request_details'],
        address: case_data['address'],
        request_type: case_data['request_type'],
        last_updated_at:  parse_time(case_data['updated']),
        neighborhood: case_data['neighborhood'],
        case_id: case_data['case_id'],
        closed_at: closed_at,
        supervisor_district: case_data['supervisor_district'],
        responsible_agency: case_data['responsible_agency'],
        opened_at: parse_time(case_data['opened']),
        latitude: case_data['point']['latitude'],
        longitude: case_data['point']['longitude']
      }
    end

    def source(name)
      @source_cache[name] ||= Source.find_or_create_by(name: name)
    end

    def category(name)
      @category_cache[name] ||= Category.find_or_create_by(name: name)
    end

    def parse_time(time_str)
      DATA_TIMEZONE.parse(time_str)
    end

    def initialize
      @source_cache = {}
      @category_cache = {}
    end
  end
end
