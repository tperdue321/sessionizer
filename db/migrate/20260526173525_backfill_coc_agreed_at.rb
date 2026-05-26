class BackfillCocAgreedAt < ActiveRecord::Migration[7.2]
  def up
     Participant.where(coc_agreed_at: nil).find_each do |participant|
       aggreement = CodeOfConductAgreement.where(participant_id: participant.id)
         .order(created_at: :desc).first
      participant.update_column(:coc_agreed_at, aggreement.created_at) if aggreement
    end
  end

  def down
    Participant.update_all(coc_agreed_at: nil)
  end
end
