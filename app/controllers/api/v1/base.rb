module API
  module V1
    class Base < Grape::API
      mount API::V1::Errors
      mount API::V1::Runners
      mount API::V1::Autobots

      # add_swagger_documentation base_path: "/api", api_version: 'v1', hide_documentation_path: true, models: [Entities::Runner, Entities::Autobot]
      add_swagger_documentation base_path: "/api", api_version: 'v1', hide_documentation_path: true
    end
  end
end
