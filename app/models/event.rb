class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  acts_as_paranoid

  attr_accessor :duration

  before_validation(on: :create) do
    self.finish = calculate_finish_date(duration) unless !finish.blank? && duration.blank?
  end

  validates_presence_of :start, message: "Invalid, can't be blank"
  validates :duration, numericality: true, allow_nil: true
  validate :start_is_a_date 
  validate :start_not_in_the_past
  
  

  scope :ordered, -> { order('start DESC') }
  scope :all_draft, -> { where("state = 'draft' and finish >= ?", Date.today) }
  scope :all_published, -> { where("state = 'published' and finish >= ?", Date.today) }
  scope :all_active, -> { where("state <> 'removed' and finish >= ?", Date.today) }

  include AASM

  aasm column: 'state' do
    state :draft, initial: true
    state :published
    event :publish do
      transitions from: :draft, to: :published, guard: :publishable?
    end
  end
  def publishable?
    !attributes.except('deleted_at').value?(nil) 
  end

  private

  def calculate_finish_date(duration)
    if start.present?
      start.to_date + duration.to_i.days
    end
  end
  def start_not_in_the_past
    if start.present? && start < Date.today
      errors.add :start, "Invalid. Can't be in the past"
    end    
  end
  def start_is_a_date
    begin
      start.to_date if start.present?
    rescue
      errors.add :start, 'Invalid, start date must be present or be a valid date'
    end
  end
  
end
