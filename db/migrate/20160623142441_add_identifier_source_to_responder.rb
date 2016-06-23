class AddIdentifierSourceToResponder < ActiveRecord::Migration
  def change
    add_column :responders, :source, :string
    add_column :responders, :identifier, :string
  end
end
