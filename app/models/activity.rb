class Activity < ActiveRecord::Base
  belongs_to :objective
  accepts_nested_attributes_for :objective
end
