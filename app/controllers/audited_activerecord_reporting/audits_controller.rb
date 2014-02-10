module AuditedActiverecordReporting
  class AuditsController < ApplicationController
    before_filter :load_resource

    def index
      unless @resource.blank?
        @audits = AuditDecorator.decorate_collection(Audit.with_associated_for(@resource)).select do |audit_presenter|
          audit_presenter.visible?
        end
      else
        @audits = AuditDecorator.decorate_collection(Audit.all).select do |audit_presenter|
          audit_presenter.visible?
        end
      end
    end

    private

    def load_resource
      if params[:resource_type] and params[:resource_id]
        resource_class = sanitize_class_name_string(params[:resource_type])
        @resource = resource_class.classify.constantize.find(params[:resource_id])
      end
    end

    def sanitize_class_name_string(class_name)
      class_name[/[^0-9][a-zA-Z0-9\-\_\!\=\?]*[^s]/]
    end
  end
end
