# frozen_string_literal: true

class ApplicationController < ActionController::API
  def render_json_with_status
    render json: @result, status: @result[:status]
  end
end
