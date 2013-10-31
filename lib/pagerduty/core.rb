class Array

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^(open|triggered|acknowledged|resolved)$/
      self.select { |incident| incident.status == meth.to_s }
    else
      # Call super so we don't mess up ruby's method lookup
      super
    end
  end

end
