module MyNamespace
  module V1
    module Mailers
      class UsersMailer
        include IdleMailer::Mailer

        def initialize(user)
          @user = user

          mail.to = user.email
          mail.subject = "#{user.name} Welcome"
        end
      end
    end
  end
end
