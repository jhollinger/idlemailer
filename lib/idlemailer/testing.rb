module IdleMailer
  # Module for testing. You can call all IdleMailer::Testing::Helpers methods directly on this module if you want.
  module Testing
    # Helpers for your tests
    module Helpers
      # Returns true if any mail was sent from the given email address.
      def sent_mail_from?(addr)
        mail_from(addr).any?
      end

      # Returns true if any mail was sent to the given email address. You may pass subject and body patterns to get more specific (String or Regexp).
      def sent_mail_to?(addr, subject = nil, body = nil)
        mail_to(addr, subject, body).any?
      end

      # Returns true if any mail was sent matching the given subject (String or Regexp).
      def sent_mail_with_subject?(pattern)
        mail_with_subject(pattern).any?
      end

      # Returns true if any mail was sent matching the given body (Regexp).
      def sent_mail_with_body?(pattern)
        mail_with_body(pattern).any?
      end

      # Returns all mail sent from the given email address.
      def mail_from(addr)
        sent_mail.select { |m| m.from.include? addr }
      end

      # Returns all mail sent to the given email address. You may pass subject and body patterns to get more specific (String or Regexp).
      def mail_to(addr, subject = nil, body = nil)
        sent_mail.select { |m|
          m.to.include?(addr) && (subject.nil? || subject === m.subject) && (body.nil? || body === m.to_s)
        }
      end

      # Returns all mail sent matching the given subject (String or Regexp).
      def mail_with_subject(pattern)
        sent_mail.select { |m| pattern === m.subject }
      end

      # Returns all mail sent matching the given body (Regexp).
      def mail_with_body(pattern)
        sent_mail.select { |m| pattern === m.to_s }
      end

      # Returns all sent mail.
      def sent_mail
        Mail::TestMailer.deliveries
      end

      # Clears sent mail.
      def clear_mail!
        Mail::TestMailer.deliveries.clear
      end
    end
    extend Helpers
  end
end
