# Controller Concern with a collection of param parsers.
module ParamParsers
  extend ActiveSupport::Concern

  # Run parsers for the given param names. Supported params are:
  # :near, :since, and :status. If any of the parsers fail the request will
  # be halted and the param errors with be returned.
  #
  # ==== Attributes
  # +parse_params+ symbols of allowed params.
  #
  # ==== Examples
  #
  # This can be ran in a before action as follows:
  # before_action -> { parse_params :near, :since }, only: :index
  def parse_params(*parse_params)
    parse_params.each do |parse_param|
      send("parse_#{parse_param}_param")
    end

    if api_errors.try(:any?)
      render status: :bad_request, json: { errors: api_errors }
      return false
    end
  end

  private

  def parse_near_param
    if params[:near]
      @near = params[:near].split(',')
      add_api_error I18n.t('errors.invalid_near_param') unless @near.size == 2
    end
  end

  def parse_since_param
    if params[:since]
      if /\A\d+\z/.match(params[:since])
        @since = Time.strptime("#{params[:since]}", '%s')
      else
        fail 'invalid since param format'
      end
    end
  rescue
    add_api_error I18n.t('errors.invalid_since_param')
  end

  def parse_status_param
    if (@status = params[:status])
      unless Sf311Case::VALID_STATUS.include?(@status.downcase)
        add_api_error I18n.t('errors.invalid_status_param')
      end
    end
  end
end
