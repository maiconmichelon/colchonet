json.array!(@rooms) do |room|
  json.extract! room, :title, :location, :description
  json.url room_url(room, format: :json)
end
