class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods

      # secret word to generate token
      private def api_secret
        "asecret!"
      end

      # gets token from Authorization key in header
      def http_token 
        @http_token ||= if request.headers['Authorization'].present? 
          request.headers['Authorization'].split(' ').last 
        end 
      end

      # add actions that don't need authentication here
      def skip_auth
        true if request.env['PATH_INFO'].include?("login") || request.env['PATH_INFO'].include?("docs")
      end

      # authentication using JWT
      def authenticate!
        unless skip_auth  # some actions do not need authentication
          begin 
            decoded_token = JWT.decode http_token, "#{api_secret}", true, { :algorithm => 'HS256' }  # checks for valid token
            @current_user = Api::Models::User[email: decoded_token[0]["data"]]  # sets logged user
          rescue JWT::VerificationError, JWT::DecodeError, JWT::ExpiredSignature
            error!('Unauthorized. Invalid or expired token.', 401) # authentication failed
          end
        end
      end

      # returns logged user
      def current_user
        @current_user
      end

      # Generates token for user to be used in other requests that need authentication
      def generate_token(email)
        exp = Time.now.to_i + (4 * 3600) # expires in 4 hrs
        payload = {data: email, exp: exp}
        JWT.encode payload, "#{api_secret}", 'HS256'
      end

    end
  end
end
