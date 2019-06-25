class CssController < ApplicationController
  skip_before_action :render_site_not_found, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[show]
  skip_after_action :verify_authorized, only: %i[show]

  def show
    id = params[:id].rpartition('-').first
    site = Site.where(id: id).where.not(css: nil).take!

    expires_in 1.year, public: true

    respond_to do |format|
      format.css { render plain: site.css }
    end
  end
end
