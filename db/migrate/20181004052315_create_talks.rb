class CreateTalks < ActiveRecord::Migration[5.1]
  def change
    create_table :talks do |t|
      t.string :content
      t.string :audio_path
      t.string :voice_id

      t.timestamps
    end
  end
end
