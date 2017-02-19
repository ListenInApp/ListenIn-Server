class User < ActiveRecord::Base
  include BCrypt

  def password
    @password ||= Password.new(passwordHash)
  end

  def password=(newPassword)
    @password = Password.create(newPassword)
    self.passwordHash = @password
  end

  # Methods for dealing with friends & Friend requests:
  def friends
    columns = [:user2]
    Friendship.where(user1: self.username, accepted: "Y").order(:user2).select(*columns)
  end

  def pendingFriendRequests
    columns = [:user1]
    Friendship.where(user2: self.username, accepted: "P").order(:user1).select(*columns)
  end

  def sentFriendRequests
    columns = [:user2, :accepted]
    Friendship.where(user1: self.username).order(:user2).select(*columns)
  end

  def addFriend(username)
    # Don't add a duplicate friendship
    unless Friendship.exists?(user1: self.username, user2: username)
      Friendship.create({
        user1: self.username,
        user2: username,
        accepted: Friendship.exists?(user1: username, user2: self.username) ? "Y" : "P"
      })

      # If the other user already sent a friend request accept it
      if Friendship.exists?(user1: username, user2: self.username)
        Friendship.where(user1: username, user2: self.username).update_all(accepted: "Y")
      end
    end
  end

  # Methods for dealing with messages:
  def messages
    columns = [:id, :sender, :type, :stillPath, :audioPath, :sentAt, :openedAt, :viewed]
    msgs = Message.where(recipient: self.username).select(*columns)

    # Sort based on the most recently accessed message
    msgs.sort {|msg1, msg2| msg1.lastTime <=> msg2.lastTime}
  end

  def message(id)
    columns = [:sender, :type, :stillPath, :audioPath, :viewed]
    msg = Message.where(recipient: self.username, id: id).select(*columns).first

    if Message.exists?(recipient: self.username, id: id) && msg.viewed < 2
      msg # If the message hasn't been viewed+replayed then return it
    else
      nil # Otherwise there's no message to show
    end
  end

  def viewMessage(id)
    msg = self.message(id)

    unless msg.nil?
      if msg.viewed == 0
        msg.viewed = 1
        msg.open
        Thread.new do
          sleep $CONFIG[:replay_time] # After the specified amount of time
          self.viewMessage(id) # Remove the ability to replay the message
        end
      elsif msg.viewed == 1
        msg.viewed = 2
        [msg.stillPath, msg.audioPath].map(:FileUtils.rm)
      end
    end
  end

  def sendMessage(usernameTo, type, stillPath = nil, audioPath)
    case type
      when :still
        Message.create({
          recipient: username,
          sender: self.username,
          type: "S",
          stillPath: stillPath,
          audioPath: audioPath
        })
      when :audio
        Message.create({
          recipient: username,
          sender: self.username,
          type: "A",
          audioPath: audioPath
        })
    end
  end
end
