class AddMetricNameToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :metric_name, :string
  end
end
