class App
  post '/createAccount' do
    content_type :json
    begin
      User.create({
        username: params[:username]
        displayName: params[:displayName]
        email: params[:email]
        password: BCrypt::Password.create(params[:password])
      })
      JSON.generate {:status => "Success"}
    rescue Exception => e
      JSON.generate {:status => "Error", :message => e}
    end
  end

  post '/changeDisplayName' do
    content_type :json

    verifyAccount params do |user|
      user.update(displayName: params[:displayName])
      JSON.generate {:status => "Success"}
    end
  end

  post '/changePassword' do
    content_type :json
    
    verifyAccount params do |user|
      user.update(password: params[:newPassword])
      JSON.generate {:status => "Success"}
    end
  end

  post '/recoverPassword' do
    content_type :json
    JSON.generate {:status => "Error", :message => "Not yet implemented"}
  end

  post '/resetPassword' do
    content_type :json
    JSON.generate {:status => "Error", :message => "Not yet implemented"}
  end

  post '/getFriends' do
    content_type :json

    verifyAccount params do |user|
      JSON.generate {:status => "Success", :friends => user.friends}
    end
  end

  post '/getFriendRequests' do
    content_type :json

    verifyAccount params do |user|
      JSON.generate {:status => "Success", :requests => user.pendingFriendRequests}
    end
  end

  post '/sentFriendRequests' do
    content_type :json

    verifyAccount params do |user|
      JSON.generate {:status => "Success", :requests => user.sentFriendRequests}
    end
  end

  post '/addFriend' do
    content_type :json

    verifyAccount params do |user|
      user.addFriend(params[:friendUsername])
      JSON.generate {:status => "Success"}
    end
  end
end
