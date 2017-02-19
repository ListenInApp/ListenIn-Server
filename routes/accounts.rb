class App
  post '/createAccount' do
    content_type :json
    begin
      User.create({
        username: params[:username],
        displayName: params[:displayName],
        email: params[:email],
        password: BCrypt::Password.create(params[:password])
      })
      {:status => "Success"}.to_json
    rescue Exception => e
      {:status => "Error", :message => e}.to_json
    end
  end

  post '/changeDisplayName' do
    content_type :json

    verifyAccount params do |user|
      user.update(displayName: params[:displayName])
       {:status => "Success"}.to_json
    end
  end

  post '/changePassword' do
    content_type :json
    
    verifyAccount params do |user|
      user.update(password: params[:newPassword])
       {:status => "Success"}.to_json
    end
  end

  post '/recoverPassword' do
    content_type :json
     {:status => "Error", :message => "Not yet implemented"}.to_json
  end

  post '/resetPassword' do
    content_type :json
     {:status => "Error", :message => "Not yet implemented"}.to_json
  end

  post '/getFriends' do
    content_type :json

    verifyAccount params do |user|
       {:status => "Success", :friends => user.friends}.to_json
    end
  end

  post '/getFriendRequests' do
    content_type :json

    verifyAccount params do |user|
       {:status => "Success", :requests => user.pendingFriendRequests}.to_json
    end
  end

  post '/sentFriendRequests' do
    content_type :json

    verifyAccount params do |user|
       {:status => "Success", :requests => user.sentFriendRequests}.to_json
    end
  end

  post '/addFriend' do
    content_type :json

    verifyAccount params do |user|
      user.addFriend(params[:friendUsername])
       {:status => "Success"}.to_json
    end
  end
end
