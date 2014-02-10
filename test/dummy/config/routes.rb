Rails.application.routes.draw do

  mount AuditedActiverecordReporting::Engine => "/audits"
end
