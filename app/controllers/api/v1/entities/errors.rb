module API
  module V1
    module Entities
       class Errors < Grape::Entity
         expose :code, documentation: { type: 'string', desc: 'Error code' }
         expose :message, documentation: { type: 'string', desc: 'Error message' }
         expose :value, documentation: { type: 'hash', desc: 'Error value' }
       end
    end
  end
end
