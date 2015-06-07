module Sf311
  # Wrapper to retrieve raw San Francisco 311 case data.
  class Api
    include HTTParty

    base_uri 'http://data.sfgov.org/resource'

    def self.cases
      get('/vw6y-z8j6.json')
    end
  end
end
