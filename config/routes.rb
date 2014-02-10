AuditedActiverecordReporting::Engine.routes.draw do
  get '*/:resource_type/:resource_id/audits' => 'audits#index'
end
