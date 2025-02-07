# == Schema Information
#
# Table name: memoids
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Memoid < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :release_dates

  # Callbacks
  after_save :create_release_dates

  # Validations
  validates :content, presence: true

  # Scope
  scope :due_today, -> do
    joins(:release_dates).where( "delivery_date = ?", Date.today )
  end

  # # prepare 'ripe' memoids for delivery
  # def self.fetch_ripe_memoids
  #   # collect ids of ripe memoids
  #   ripe_memoids = Memoid.due_today.map(&:id)
  # end

  def next_delivery_date
    self.release_dates.first.delivery_date
  end

  private
    def create_release_dates
      self.release_dates << ( ReleaseDate.create delivery_date: Date.today + 1)
    end
end
