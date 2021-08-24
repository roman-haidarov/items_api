class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from JWT::DecodeError, with: :render_parse_error

  include AccessHandler

  private

  def render_not_found
    render_response_application({ message: "Record not found" }, 404) 
  end

  def render_parse_error
    render_response_application({ message: "Invalid token" }, 400)
  end

  def render_unauthorize
    render_response_application({ message: "Access Denied"}, 403)
  end

  def render_response_application(value, status)
    render json: value, status: status
  end
end
