module API
  module V1
    class Runners < Grape::API
      include API::V1::Defaults

      resource :runners do
        desc 'Update image'
        params do
          requires :file, type: Rack::Multipart::UploadedFile, desc: "ex: quang"
        end
        post 'upload' do
          # # filename = params[:file][:filename]
          # # content_type 'application/octet-stream'
          # # env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
          # # header 'Content-Disposition', "attachment; filename*=UTF-8''#{URI.escape(filename)}"
          # # params[:file][:tempfile].read
          # new_file = ActionDispatch::Http::UploadedFile.new(params[:file])
        end

        desc "Create runner"
        params do
          requires :full_name, type: String, desc: "ex: quang"
          requires :email, type: String, desc: "ex: example@abc.com"
          requires :age, type: Integer
          requires :password, type: String
          requires :avatar, type: Rack::Multipart::UploadedFile, desc: "ex: quang"
          optional :country, type: String
          optional :registration_id, type: String
          optional :notification_key, type: String
        end
        post :create, http_codes: [
          [200, 'Ok', Entities::Runner],
          ['400 - e2', ErrorCodes.get('e2')[:message], Entities::Errors]
        ] do
          # insert avatar
          # # filename = params[:file][:filename]
          # # content_type 'application/octet-stream'
          # # env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
          # # header 'Content-Disposition', "attachment; filename*=UTF-8''#{URI.escape(filename)}"
          # # params[:file][:tempfile].read
          # new_file = ActionDispatch::Http::UploadedFile.new(params[:file])

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
      end
    end
  end
end

