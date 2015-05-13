module API
  module V1
    class Runners < Grape::API
      include API::V1::Defaults

      resource :runners do
        desc "Send to GCM"
        params do
          requires :name, type: String
        end
        get :gcm, http_codes: [
          [200, 'Ok', Entities::Client],
          ['400 - e1', ErrorCodes.get('e1')[:message], Entities::Errors]
        ] do
          gcm = GCM.new("AIzaSyBPAPHg5Fb2OE_kkvLm_wVy6Jm1sQLNIpU")
          # you can set option parameters in here
          #  - all options are pass to HTTParty method arguments
          #  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
          #  gcm = GCM.new("my_api_key", timeout: 3)

          registration_ids= ["APA91bHVGSuRw0KH7zZ5lNJm2onFZhZP2HxasIxMsoDUo6glEWkJAXys6EiCffaWDyPns3SrKuJFRlqBZNVBt7rGvm4uqVJt9JNiQg59UeNmBw4dWGJlHnnY_1RHqh2z25r3rLbdu_2r"] # an array of one or more client registration IDs
          options = {data: {score: "123"},dry_run: true}
          response = gcm.send(registration_ids, options)
        end

        desc "Get runner info"
        params do
          requires :email, type: String
        end
        get :info, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e1', ErrorCodes.get('e1')[:message], Entities::Errors]
        ] do
          runner = Runner.find_by(email: params[:email])
          present runner, with: Entities::Runner
        end

        desc "Create runner"
        params do
          requires :full_name, type: String, desc: "ex: quang"
          requires :email, type: String, desc: "ex: example@abc.com"
          requires :age, type: Integer
          requires :password, type: String
          optional :country, type: String
          optional :registration_id, type: String
          optional :notification_key, type: String
        end
        post :create, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e2', ErrorCodes.get('e2')[:message], Entities::Errors]
        ] do

          runner_params = {
            full_name: params[:full_name],
            email: params[:email],
            age: params[:age],
            password: params[:password],
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

        desc "Delete client"
        params do
          requires :name, type: String, desc: "ex: quang"
        end
        delete :delete, http_codes: [
          [200, 'Ok', Entities::Client],
          ['400 - e3', ErrorCodes.get('e3')[:message], Entities::Errors]
        ] do
          if params[:name] == '1'
            error!(ErrorCodes.get('e3', 'name'), 400)
            return
          end

          client = Client.find_by(name: params[:name])
          client.destroy
          present client, with: Entities::Client, type: :full
        end
      end
    end
  end
end

