module AuditedActiverecordReporting
  class AuditsController < ApplicationController
    before_filter :load_resource

    def index
      @audits = AuditDecorator.decorate(Audit.with_associated_for(@resource)).select do |audit_presenter|
        audit_presenter.visible?
      end
    end

    private

    def load_resource
      if params[:resource_type] and params[:resource_id]
        @resource = params[:resource_type].to_s.classify.constantize.find(params[:resource_id])
      end
    end
  end
end
