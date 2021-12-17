class Admin::StaticPagesController < Admin::BaseController
  authorize_resource class: false

  def index; end
end
