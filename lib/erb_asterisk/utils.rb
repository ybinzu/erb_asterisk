module ErbAsterisk
  module Utils
    # Escape special symbols in extension name
    #
    # vnov -> v[n]ov
    # LongExtension1234! -> Lo[n]gE[x]te[n]sio[n]1234[!]
    #
    def escape_exten(exten)
      result = exten.each_char.reduce('') do |s, c|
        s << (%w(x z n . !).include?(c.downcase) ? "[#{c}]" : c)
      end

      log_debug("escape_exten: '#{exten}' => '#{result}'", 2)
      result
    end
  end
end
