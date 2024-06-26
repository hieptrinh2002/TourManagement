# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, Tour
    can :create, User
    can :read, Review

    return if user.blank?

    can :read, Voucher

    if user.admin?
      can [:read, :create, :update, :remove_image], Tour
      can [:read, :update], Booking
      can :manage, Voucher
      can :manage, Admin

    else
      can [:read, :update, :cancel], Booking, user_id: user.id
      can [:create], Booking
      can [:read, :update], User, id: user.id
      can :manage, Review
    end
  end
end
