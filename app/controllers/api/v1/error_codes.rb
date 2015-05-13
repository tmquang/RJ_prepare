module API
  module V1
    class ErrorCodes
      @errors = {
        e1: 'An unknown error occurred',
        e2: 'Application does not have permission for this action',
        e3: 'Invalid parameter'
      }

      def self.get(code, value = nil)
        error = {
          code: code,
          message: @errors[code.to_sym],
          value: value
        }
        return Entities::Errors.represent(error).as_json
      end

      def self.list
        return @errors
      end
    end
  end
end
