module API
  module V1
    class Runners < Grape::API
      include API::V1::Defaults

      resource :runners do
        desc "Create runner"
        params do
          requires :full_name, type: String, desc: "ex: quang"
          requires :email, type: String, desc: "ex: example@abc.com"
          requires :age, type: Integer
          requires :password, type: String
          requires :password_confirmation, type: String
          optional :avatar, type: Rack::Multipart::UploadedFile
          optional :country, type: String
          optional :registration_id, type: String
          optional :notification_key, type: String
        end
        post '/', http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e2', ErrorCodes.get('e2')[:message], Entities::Errors]
        ] do

          avatar = ActionDispatch::Http::UploadedFile.new(params[:avatar]) rescue avatar = nil
          runner_params = {
            full_name: params[:full_name],
            avatar: avatar,
            email: params[:email],
            age: params[:age],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            country: params[:country],
            registration_id: params[:registration_id],
            notification_key: params[:notification_key]
          }

          runner = Runner.new(runner_params)

          # check valid params
          if runner.invalid?
            error!(ErrorCodes.get('e3', runner.errors), 400)
            return
          end

          runner.save
          present runner, with: Entities::Runner, type: :full
        end

        desc "Update avatar"
        params do
          requires :avatar, type: Rack::Multipart::UploadedFile
        end
        put :update_avatar, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e2', ErrorCodes.get('e2')[:message], Entities::Errors]
        ] do
          # authentication
          doorkeeper_authorize!
          owner_id = doorkeeper_token.resource_owner_id

          runner = Runner.find_by(id: owner_id)

          # check exists
          if runner.nil?
            error!(ErrorCodes.get('e2'), 400)
            return
          end

          avatar = ActionDispatch::Http::UploadedFile.new(params[:avatar]) rescue avatar = nil
          runner.avatar = avatar

          # check valid params
          if runner.invalid?
            error!(ErrorCodes.get('e3', runner.errors), 400)
            return
          end

          runner.save
          present runner, with: Entities::Runner, type: :full
        end

        desc "Update runner"
        params do
          optional :full_name, type: String, desc: "ex: quang"
          optional :age, type: Integer
          optional :old_password, type: String
          optional :new_password, type: String
          optional :password_confirmation, type: String
          optional :country, type: String
          optional :registration_id, type: String
          optional :notification_key, type: String
        end
        put '/', http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e2', ErrorCodes.get('e2')[:message], Entities::Errors]
        ] do
          # authentication
          doorkeeper_authorize!
          owner_id = doorkeeper_token.resource_owner_id

          runner = Runner.find_by(id: owner_id)

          # check exists
          if runner.nil?
            error!(ErrorCodes.get('e2'), 400)
            return
          end

          runner.full_name = params[:full_name] unless params[:full_name].nil?
          runner.age = params[:age] unless params[:age].nil?

          # update password
          unless params[:old_password].nil?
            return error!(ErrorCodes.get('e3', {old_password: "wrong password"}), 400) unless runner.authenticate(params[:old_password])
            return error!(ErrorCodes.get('e3', {new_password: "password not match"}), 400) unless params[:new_password] == params[:password_confirmation]
            runner.password = params[:new_password]
            runner.password_digest = BCrypt::Password.create(params[:new_password])
          end

          runner.country = params[:country] unless params[:country].nil?
          runner.registration_id = params[:registration_id] unless params[:registration_id].nil?
          runner.notification_key = params[:notification_key] unless params[:notification_key].nil?

          # check valid params
          if runner.invalid?
            error!(ErrorCodes.get('e3', runner.errors), 400)
            return
          end

          # runner.update(update_params)
          runner.save

          present runner, with: Entities::Runner, type: :full
        end

        desc "Get runner info"
        get :info, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e1', ErrorCodes.get('e1')[:message], Entities::Errors]
        ] do
          # authentication
          doorkeeper_authorize!
          owner_id = doorkeeper_token.resource_owner_id

          runner = Runner.find_by(id: owner_id)
          present runner, with: Entities::Runner
        end

        desc "Find by email"
        params do
          requires :email, type: String
        end
        get :find_by_email, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e1', ErrorCodes.get('e1')[:message], Entities::Errors]
        ] do
          # authentication
          doorkeeper_authorize!
          owner_id = doorkeeper_token.resource_owner_id

          runner = Runner.find_by(email: params[:email])
          present runner, with: Entities::Runner
        end
      end
    end
  end
end

