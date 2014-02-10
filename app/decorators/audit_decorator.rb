class AuditDecorator < Draper::Base
  decorates :audit

  def action
    presenter.action
  end

  def changes
    return unless visible?

    leading_content = h.content_tag :div, class: 'lead audit-change' do
      h.content_tag(:span, action, class: "label #{h.bootstrap_class(audit.action, type: 'label')}") +
      name
    end

    audited_content = h.div_for audit, class: 'collapse' do
      changes_table class: 'table table-striped table-bordered'
    end

    leading_content + audited_content
  end

  def changes_table(options ={})
    thead = h.content_tag :thead do
      h.content_tag :tr do
        h.content_tag(:th, I18n.translate("audit.changes.attribute")) +
        h.content_tag(:th, I18n.translate("audit.changes.from")) +
        h.content_tag(:th, I18n.translate("audit.changes.to"))
      end
    end

    tbody = h.content_tag :tbody do
      audited_changes.collect do |field, change|
        h.content_tag :tr do
          h.content_tag(:td, field_name(field)) +
          h.content_tag(:td, change[:from]) +
          h.content_tag(:td, change[:to])
        end
      end.join("").html_safe
    end

    h.content_tag :table, options do
      thead + tbody
    end
  end

  def audited_changes
    presenter.audited_changes
  end

  def author
    h.content_tag :strong, class: 'text-info' do
      h.content_tag(:span, author_name, class: 'muted') +
      h.content_tag(:br) +
      h.content_tag(:em, Audit.human_attribute_name(:created_at, datetime: audit.created_at))
    end
  end

  def author_name
    presenter.author_name
  end

  def field_name(field)
    presenter.field_name(field)
  end

  def name
    presenter.name
  end

  def visible?
    presenter.visible?
  end

  protected
  def field_name(field)
    (audit.revision || audit.auditable).class.human_attribute_name(field).downcase
  end

  private
  def presenter
    begin
      @presenter ||= "AuditPresenter::#{audit.auditable_type}".constantize.new(audit, self)
    rescue NameError => e
      @presenter = AuditPresenter::Base.new(audit, self)
    end
  end
end
