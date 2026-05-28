class BackfillCocAgreedAt < ActiveRecord::Migration[7.2]
  # Raw SQL on purpose: this backfills from code_of_conduct_agreements, a table
  # slated for removal. Referencing the CodeOfConductAgreement model would break
  # this migration on replay once that model is deleted.
  def up
    execute(<<~SQL)
      UPDATE participants
      SET coc_agreed_at = coc.last_agreed_at
      FROM (
        SELECT participant_id, MAX(created_at) AS last_agreed_at
        FROM code_of_conduct_agreements
        GROUP BY participant_id
      ) AS coc
      WHERE participants.id = coc.participant_id
        AND participants.coc_agreed_at IS NULL
    SQL
  end

  def down
    # no-op: backfilled timestamps are indistinguishable from organic agreements
  end
end
