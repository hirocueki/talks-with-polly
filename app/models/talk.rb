class Talk < ApplicationRecord
  validates :content, presence: true, length: { maximum: 3000 }
  enum voice_list: {
    Mizuki: 0,
    Takumi: 1,
  }

  def voice_jp
    Talk.voice_lists_i18n.each do |k,v|
      if k == self.voice_id
        return v
      end
    end
    self.voice_id
  end
end
