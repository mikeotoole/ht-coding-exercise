namespace :sf311 do
  desc 'Import latest data from San Francisco 311 Case API'
  task import: :environment do
    begin
      require 'sf311/importer'
      Sf311::Importer.new.import!
    rescue => e
      # Send Exception to Airbrake etc. so task does not silently fail when ran
      # via Cron.
      raise e
    end
  end
end
