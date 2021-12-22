class Admin::StaticPagesController < Admin::BaseController
  authorize_resource class: false

  def index; end

  def order_status
    render json: Order.group(:status).size
  end

  def order_total_money_month
    render json: Order.group_by_month(:created_at).sum(:total_of_money)
  end

  def order_total_money_quarter
    render json: Order.group_by_quarter(:created_at).sum(:total_of_money)
  end

  def order_total_money_year
    render json: Order.group_by_year(:created_at).sum(:total_of_money)
  end

  def order_accept_month
    render json: Order.accept.group_by_month(:created_at).size
  end

  def order_accept_quarter
    render json: Order.accept.group_by_quarter(:created_at).size
  end

  def order_accept_year
    render json: Order.accept.group_by_year(:created_at).size
  end
end
