module API
  module V1
    class Errors < Grape::API
      include API::V1::Defaults

      resource :errors do
        desc "Return error info"
        params do
          requires :code, type: String, desc: "ex: e1"
        end
        get :info do
          ErrorCodes.get(params[:code])
        end

        desc "List error_codes"
        get :list do
          ErrorCodes.list
        end
      end
    end
  end
end
