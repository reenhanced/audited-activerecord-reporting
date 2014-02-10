class Audit < Audited::Adapters::ActiveRecord::Audit

  def self.with_associated_for(auditor = nil)
    return [] unless auditor
    where(
      arel_table[:auditable_id].eq(auditor.id).and(
        arel_table[:auditable_type].eq(auditor.class.to_s)
      ).or(
        arel_table[:associated_id].eq(auditor.id).and(
          arel_table[:associated_type].eq(auditor.class.to_s)
        )
      )
    ).reorder('created_at DESC, version DESC')
  end

  # :nodoc:
  def inspect
    association = ''
    association = " (associated with #{associated_type}[#{associated_id}])" if associated_type.present?

    "\"[id:#{id}] #{action} #{auditable_type}[#{auditable_id}]#{association} by user_id:#{user_id} @ #{created_at} => #{audited_changes.inspect}\""
  end
end
