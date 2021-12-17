class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    return if user.blank?

    if user&.user?
      can :manage, :cart
      can :manage, Order, user_id: user.id
    end

    can :manage, :all if user&.admin?
  end
end
