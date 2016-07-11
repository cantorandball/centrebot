class AddStateToResponder < ActiveRecord::Migration
  def change
    add_column :responders, :state, :string
  end
end
