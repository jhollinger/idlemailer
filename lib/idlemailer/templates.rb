module IdleMailer
  module Templates
    def self.compile(src)
      compiler = ERB::Compiler.new("<>")
      compiler.pre_cmd = ["_erbout=+HtmlSafeString.new"]
      compiler.put_cmd = "_erbout.safe_concat"
      compiler.insert_cmd = "_erbout.<<"
      compiler.post_cmd = ["_erbout"]
      code, _enc = compiler.compile(src)
      Template.new code.freeze
    end

    Template = Struct.new(:code) do
      def result(bind)
        _erbout = HtmlSafeString.new
        eval code, bind
      end
    end

    module Helpers
      # Don't HTML-escape the given value
      def raw(str)
        HtmlSafeString.new(str)
      end
    end
  end
end
