AuditedActiverecordReporting::Engine.routes.draw do
  match ':resource_type/:resource_id/audits' => 'audits#index'
  match '*parent_resource_type/:parent_resource_id/:resource_type/:resource_id/audits' => 'audits#index'

  match '/audits' => 'audits#index'
end
