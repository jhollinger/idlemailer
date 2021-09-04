module IdleMailer
  class HtmlSafeString < String
    def <<(str)
      safe_str = str.is_a?(HtmlSafeString) ? str : ERB::Util.html_escape(str.to_s)
      super safe_str
    end

    def safe_concat(val)
      self << HtmlSafeString.new(val)
    end

    def to_s
      self
    end
  end
end
