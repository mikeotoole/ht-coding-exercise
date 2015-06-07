# Root Controller Used for code shared between controllers.
class ApplicationController < ActionController::Base
  layout 'api_json'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  attr_reader :api_errors

  # Decodes pagination info. This is only loaded by
  # controllers actions that need it.
  def load_pagination
    @page = params[:page].try(:to_i) || 1
    @per_page = params[:per_page].try(:to_i) || 10
    if @page < 0
      response = {
        errors: [I18n.t('errors.negative_page')]
      }
      render status: :bad_request, json: response
      return false
    end
  end

  def add_api_error(error)
    (@api_errors ||= []) << error
  end
end
