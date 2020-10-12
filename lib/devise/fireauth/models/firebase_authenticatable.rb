# frozen_string_literal: true
require "active_support/concern"

module Devise
  module Models
    module FirebaseAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor Fireauth.token_key
      end

      module ClassMethods
        def from_firebase(auth_hash)
          raise NotImplementedError,
            "#{self.name} model must implement class method `from_firebase'"
        end

        #
        # Here you do the request to the external webservice
        #
        # If the authentication is successful you should return
        # a resource instance
        #
        # If the authentication fails you should return false
        #
        def firebase_authentication(id_token)
          auth_hash = firebase_verification(id_token)
          return nil if auth_hash.empty?
          # Create new user here and return user
          self.from_firebase(auth_hash)
        end

        private

        def firebase_verification(id_token)
          Fireauth.firebase_validator.check id_token
        rescue => e
          puts e.message
          {}
        end
      end
    end
  end
end
