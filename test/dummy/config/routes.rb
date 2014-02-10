Rails.application.routes.draw do

  mount AuditedActiverecordReporting::Engine => "/audited-activerecord-reporting"
end
