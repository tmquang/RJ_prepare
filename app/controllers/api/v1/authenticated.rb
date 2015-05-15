module API
  module V1
    module Authenticated
      extend ActiveSupport::Concern
      include V1::Defaults

      included do
        # HTTP header based authentication
        before do
          doorkeeper_authorize!
        end
      end
    end
  end
end
