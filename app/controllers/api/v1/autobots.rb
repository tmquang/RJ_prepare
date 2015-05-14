module API
  module V1
    class Autobots < Grape::API
      include API::V1::Defaults

      resource :autobots do
        desc "Create autobot"
        params do
          requires :speed, type: Float
          requires :calories, type: Float
          requires :heart_rate, type: Integer
          requires :rank, type: Integer
          optional :avatar, type: Rack::Multipart::UploadedFile
        end
        post '/', http_codes: [
          [201, 'created', Entities::Autobot],
          ['400 - e3', ErrorCodes.get('e3')[:message], Entities::Errors]
        ] do
          avatar = ActionDispatch::Http::UploadedFile.new(params[:avatar]) rescue avatar = nil
          autobot_params = {
            speed: params[:speed],
            calories: params[:calories],
            heart_rate: params[:heart_rate],
            rank: params[:rank],
            avatar: avatar
          }

          autobot = Autobot.new(autobot_params)

          # check valid params
          if autobot.invalid?
            error!(ErrorCodes.get('e3', autobot.errors), 400)
            return
          end

          autobot.save
          present autobot, with: Entities::Autobot
        end

        desc "Update autobot"
        params do
          requires :autobot_id, type: Integer
          requires :speed, type: Float
          requires :calories, type: Float
          requires :heart_rate, type: Integer
          requires :rank, type: Integer
          optional :avatar, type: Rack::Multipart::UploadedFile
        end
        put '/', http_codes: [
          [200, 'Ok', Entities::Autobot],
          ['400 - e3', ErrorCodes.get('e3')[:message], Entities::Errors]
        ] do
          doorkeeper_token.resource_owner_id

          autobot = Autobot.find_by(id: params[:autobot_id])

          # check exists
          if autobot.nil?
            error!(ErrorCodes.get('e3', {"autobot_id": "not exists"}), 400)
            return
          end

          autobot.speed = params[:speed]
          autobot.calories = params[:calories]
          autobot.heart_rate = params[:heart_rate]
          autobot.rank = params[:rank]
          avatar = ActionDispatch::Http::UploadedFile.new(params[:avatar]) rescue avatar = nil
          autobot.avatar = avatar

          # check valid params
          if autobot.invalid?
            error!(ErrorCodes.get('e3', autobot.errors), 400)
            return
          end

          autobot.save
          present autobot, with: Entities::Autobot
        end

        desc "Delete autobot"
        params do
          requires :autobot_id, type: Integer
        end
        delete '/', http_codes: [
          [200, 'Ok', Entities::Autobot],
          ['400 - e3', ErrorCodes.get('e3')[:message], Entities::Errors]
        ] do
          if params[:name] == '1'
            error!(ErrorCodes.get('e3', 'name'), 400)
            return
          end

          autobot = Autobot.find_by(id: params[:autobot_id])

          # check exists
          if autobot.nil?
            error!(ErrorCodes.get('e3', {"autobot_id": "not exists"}), 400)
            return
          end

          autobot.destroy
          present autobot, with: Entities::Autobot
        end

        desc "Get list autobots"
        get :list, http_codes: [
          [200, 'Ok', Entities::Autobot]
        ] do
          autobot = Autobot.all
          present autobot, with: Entities::Autobot
        end

        desc "Get autobot info"
        params do
          requires :rank, type: Integer
        end
        get :info, http_codes: [
          [200, 'Ok', Entities::Autobot]
        ] do
          autobot = Autobot.find_by(rank: params[:rank])
          begin
            data = JSON.parse(autobot.to_json,:symbolize_names => true)
            data[:avatar] = {
              origin: autobot.avatar.url,
              thumb: autobot.avatar.url(:thumb),
              medium: autobot.avatar.url(:medium),
            }
          rescue
            data = nil
          end
          present data, with: Entities::Autobot
        end
      end
    end
  end
end

