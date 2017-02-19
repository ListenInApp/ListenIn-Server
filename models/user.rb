class User < ActiveRecord::Base
  # Methods for dealing with friends & Friend requests:
  def friends
    columns = [:user2, :accepted]
    Friendship.where(user1: self.username, accepted: "Y").order(:username).select(*columns)
  end

  def pendingFriendRequests
    columns = [:user1]
    Friendship.where(user2: self.username, accepted: "P").order(:username).select(*columns)
  end

  def sentFriendRequests
    columns = [:user2, :accepted]
    Friendship.where(user1: self.username).order(:username).select(*columns)
  end

  def addFriend(username)
    # Get any existing friend requests for that user
    columns = [:accepted]
    request = Friendship.where(user1: username, user2: self.username).select(*columns).first
 
    # State to change the "accepted" status to based on current request status
    accepted = {"P" => "Y", "N" => "N"}
    accepted.default = "P"

    # Don't add a duplicate friendship
    unless Friendship.where(user1: self.username, user2: username).nil?
      Friendship.create({
        user1: self.username,
        user2: username,
        accepted: accepted[request]
      })

      # If the other user already sent a friend request accept it
      unless request.nil?
        Friendship.where(user1: username, user2: self.username).update(accepted: "Y")
      end
    end
  end

  # Methods for dealing with messages:
  def messages
    columns = [:id, :sender, :type, :stillPath, :audioPath, :sentAt, :openedAt, :viewed]
    msgs = Messages.where(recipient: self.username).select(*columns)

    # Sort based on the most recently accessed message
    msgs.sort {|msg1, msg2| msg1.lastTime <=> msg2.lastTime}
  end

  def message(id)
    columns = [:sender, :type, :stillPath, :audioPath, :viewed]
    msg = Message.where(recipient: self.username, id: id).select(*columns).first

    if msg.viewed < 2
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
