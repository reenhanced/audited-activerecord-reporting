module AuditedActiverecordReporting
  module ApplicationHelper
    def bootstrap_class(type, options = {})
      prefix = options.delete(:type) || 'text'

      case type.to_s
        when /positive|update/
          "#{prefix}-success"
        when /neutral/
          "#{prefix}-warning"
        when /negative|destroy/
          (prefix.to_s == 'label') ? "label-important" : "text-error"
        when /notice|create/
          "#{prefix}-info"
        when /error/
          "alert-error"
        when /alert/
          "alert-block"
        when /success/
          "alert-success"
        else
          type.to_s
      end
    end
  end
end
