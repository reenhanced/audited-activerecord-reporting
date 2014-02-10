module AuditedActiverecordReporting
  class AuditPresenter::Base
    def initialize(audit, decorator)
      @audit = audit
      proxy_view_helpers(decorator)
    end

    def action
      "#{I18n.translate("audit.actions.#{audit.action}")} #{humanized_class_name}"
    end

    def author_name
      if audit.user.present? and audit.user.to_s.present?
        audit.user.to_s
      else
        I18n.translate("audit.system_username")
      end
    end

    def name
      if audit.auditable.present?
        audit.auditable.to_s
      else
        audit.revision.to_s
      end
    end

    def visible?
      audited_changes.any?
    end

    def audited_changes
      # keep a cached version
      return @audited_changes if @audited_changes.present?

      @audited_changes = {}
      audit.audited_changes.each do |field, change|
        from, to = changeset_for(field, change)
        if from.present? or to.present?
          @audited_changes[field.to_sym] = {from: from, to: to}
        end
      end
      @audited_changes
    end

    protected
    def changeset_for(field, change)
      if respond_to?(:"#{field}_change")
        send("#{field}_change", change)
      else
        if change.is_a?(Array)
          [changed_field_from(field, change[0]), changed_field_to(field, change[1])]
        else
          [nil, changed_field_to(field, change)]
        end
      end
    end

    def changed_field_from(field, value)
      # first we check for associated objects and try to print the associated value from the revision if it still exists
      if field =~ /_id$/
        field = field.to_s.gsub(/_id$/, '').strip.to_sym
        if audit.revision.present? and audit.revision.respond_to?(field)
          return audit.revision.try(field) || value
        end
      end

      value
    end

    def changed_field_to(field, value)
      # if the field is an association, we'll try to print the associated value
      field = field.to_s.gsub(/_id$/, '').strip.to_sym if field.to_s =~ /_id$/
      if audit.revision.respond_to?(field)
        audit.revision.try(field) || value
      else
        value
      end
    end

    private
    def proxy_view_helpers(decorator)
      self.class.send(:define_method, :h) do
        decorator.helpers
      end
    end

    def humanized_class_name
      audit.auditable_type.titleize
    end

    def audit
      @audit
    end

    def change_type(change)
      change[1].class
    end
  end
end
