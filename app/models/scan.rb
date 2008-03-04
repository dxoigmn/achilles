class Scan < ActiveRecord::Base
  has_many :hosts
  belongs_to :location
  
  acts_as_state_machine :initial => :waiting

  state :waiting
  state :running
  state :finished
  
  event :start do
    transitions :to => :running, :from => :waiting
  end
  
  event :stop do
    transitions :to => :finished, :from => :running
  end
end
