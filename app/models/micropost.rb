class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  # other scoping mechanisms like named_scope may be better in general
  default_scope :order => 'microposts.created_at DESC' # DESC is sql for 'descending'
end
