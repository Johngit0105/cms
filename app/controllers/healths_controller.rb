class HealthsController < ApplicationController
  skip_before_action :render_site_not_found
  skip_before_action :authenticate_user!
  skip_authorization_check

  def show
    respond_to do |format|
      format.text { render text: 'ok' }
    end
  end
end
