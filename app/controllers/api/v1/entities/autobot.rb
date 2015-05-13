module API
  module V1
    module Entities
      class Autobot < Grape::Entity
        expose :id, documentation: { type: 'integer' }
        expose :speed, documentation: { type: 'float' }
        expose :calories, documentation: { type: 'float' }
        expose :heart_rate, documentation: { type: 'integer' }
        expose :rank, documentation: { type: 'integer' }
        expose :avatar
      end
    end
  end
end
