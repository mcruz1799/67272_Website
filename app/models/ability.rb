# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    #set user to new employee if not logged in
    user ||= Employee.new


    #set authorization for different user roles
    if user.role? :admin
      can :manage, :all
    
    elsif user.role? :manager
      # can edit employees, list all employees and view their details (for employees at their stores)
      can :index, Employee
      can [:show,:edit,:update], Employee do |this_employee|
        this_employee.current_assignment.store.name == user.current_assignment.store.name
      end
      #can index stores and show the store their currently assigned to
      can :index, Store
      can :show, Store do |this_store|
        user.current_assignment.store.name == this_store.name
      end
      # can index assignments and show assignments at their store
      can :index, Assignment 
      can :show, Assignment do |this_assignment| 
        this_assignment.store.name == user.current_assignment.store.name
      end
      # can view, add, edit or delete shifts
      can :manage, Shift 
      # can add and remove jobs from shifts
      can :manage, ShiftJob
      # can view list of jobs
      can :index, Job 

    elsif user.role? :employee
      # can view theirself
      can [:show, :edit, :update], Employee do |employee|
        employee.id == user.id
      end
      # can view their shifts
      can :show, Shift do |this_shift| 
        my_shifts = Shift.for_employee(user).map(&:id)
        my_shifts.include? this_shift.id
      end
      #can index assignments and show their assignments
      can :index, Assignment
      can :show, Assignment do |this_assignment|
        my_assignments = Assignment.for_employee(user).map(&:id)
        my_assignments.include? this_assignment.id
      end

    # else #guests


    end

  end
end
