module API
  module V1
    module Entities
      class Runner < Grape::Entity
        expose :full_name, documentation: { type: 'string', desc: 'full name' }
        expose :email, documentation: { type: 'string' }
        expose :age, documentation: { type: 'string' }
        expose :country, documentation: { type: 'string' }
        expose :avatar
        expose :registration_id, documentation: { type: 'string', desc: 'registration_id of GCM' },
          if: lambda { |instance, options| options[:type] == :full }
        expose :notification_key, documentation: { type: 'string', desc: 'notification_key of GCM' },
          if: lambda { |instance, options| options[:type] == :full }
      end
    end
  end
end
