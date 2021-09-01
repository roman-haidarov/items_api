class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from JWT::DecodeError, with: :render_parse_error

  include AccessHandler

  private

  def render_not_found
    render_response({ message: "Record not found" }, 404) 
  end

  def render_parse_error
    render_response({ message: "Invalid token" }, 400)
  end

  def render_unauthorize
    render_response({ message: "Access Denied"}, 403)
  end

  def render_response(value, status)
    render json: value, status: status
  end
end
