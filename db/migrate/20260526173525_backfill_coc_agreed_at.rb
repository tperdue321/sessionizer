class BackfillCocAgreedAt < ActiveRecord::Migration[7.2]
  def up
    ActiveRecord::Base.connection.execute(<<~SQL)
      UPDATE participants
      SET coc_agreed_at = coc.created_at
      FROM (
        SELECT DISTINCT ON (participant_id) participant_id, created_at
        FROM code_of_conduct_agreements
      ) AS coc
      WHERE participants.id = coc.participant_id
      AND participants.coc_agreed_at IS NULL
    SQL
  end

  def down
    Participant.update_all(coc_agreed_at: nil)
  end
end
