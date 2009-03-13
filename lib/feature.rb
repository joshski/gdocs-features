class Feature
  def reformat
    indent(body).join("\n")
  end
  
  def indent(lines)
    result = []
    tabs = ""
    lines.map do |line|
      if line =~ /^feature\:/i
        result << line + "\n"
        tabs = "  "
      elsif line =~ /^scenario\:/i
        result << "\n    " + line + "\n"
        tabs = "      "
      else
        result << tabs + line
      end
    end
    result
  end
  
  def body
    []
  end
end