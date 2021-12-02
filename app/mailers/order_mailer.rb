class OrderMailer < ApplicationMailer
  def change_status_order user, order_status
    @user = user
    @order_status = order_status
    mail to: user.email, subject: t("orders.change_status")
  end
end
