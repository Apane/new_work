class AddIndentifiersToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :for_about, :boolean
    add_column :questions, :for_personality, :boolean
  end
end
