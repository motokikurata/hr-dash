class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.integer :user_id,       null: false
      t.text :body,             null: false
      t.string :referer
      t.string :user_agent
      t.string :session_id

      t.timestamps null: false
    end
  end
end
