class Message < ActiveRecord::Base
  def viewed
    self.viewed
  end

  def viewed=(newViewed)
    self.viewed = newViewed
  end

  def lastTime
    if self.openedAt.nil?
      self.sentAt
    else
      self.openedAt
    end
  end

  def open
    # Update the time that the message was opened at
    self.openedAt = DateTime.now unless self.viewed > 0
  end
end
