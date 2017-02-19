class App
  post '/getMessages' do
    content_type :json

    verifyAccount params do |user|
      {:status => "Success", :messages => user.messages}.to_json
    end
  end

  post '/getMessage' do
    content_type :json

    verifyAccount params do |user|
      msg = user.message(id)
      unless msg.nil?
        {:status => "Success", :message => user.message(id)}.to_json
      else
        {:status => "Error", :message => "That message does not exist"}.to_json
      end
    end
  end

  post '/viewMessage' do
    content_type :json

    verifyAccount params do |user|
      user.viewMessage(params[:id])
      {:status => "Success"}.to_json
    end
  end

  post '/sendMessage' do
    content_type :json

    verifyAccount params do |user|
      recipients = params[:to]
      
      def handleUpload(file, &block)
        # Find a unique string for the filename in the upload directory
        filename = ''
        while filename == '' || File.exist?(filename)
          # Generate a random string of 16 characters between '0' and '~'
          randStr = (0..16).map{(48 + rand(78)).chr}.join
          filename = $CONFIG[:upload_directory] + file[:filename] + randStr
        end

        begin
          File.open(filename, "w") do |f|
            f.write(file[:tempfile].read)
          end
        rescue Exception => e
          {:success => "Error", :message => "Could not upload message"}.to_json
        end

        block.call filename
      end

      createMessage = case params[:type]
        when 'Audio'
          handleUpload params[:audioFile] do |audioPath|
            Proc.new do |recipient|
              user.sendMessage(to: recipient, type: :Audio, audioPath: audioPath)
            end
          end
        when 'Still'
          handleUpload params[:audioFile] do |audioPath|
            handleUpload params[:stillFile] do |stillPath|
              Proc.new do |recipient|
                user.sendMessage(to: recipient, type: :Still, stillPath: stillPath, audioPath: audioPath)
              end
            end
          end
      end

      recipients.each(createMessage)

      {:status => "Success", :messages => user.messages}.to_json
    end
  end
end
