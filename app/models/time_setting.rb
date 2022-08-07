class TimeSetting < ApplicationRecord
  belongs_to :user

  validates :randomized, inclusion: {in: [true, false]}
  validates :costom_time, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60}
end
