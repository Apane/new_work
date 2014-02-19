json.array!(@activities) do |activity|
  json.extract! activity, :title, :description, :location, :date, :time, :activity_date, :lat, :lng, :location, :location_name, :activity_type, :postal_code, :country, :state, :city, :frequency_id, :category_id, :gender, :ethnicity_id, :age_min, :age_max
  json.url activity_url(activity, format: :json)
end