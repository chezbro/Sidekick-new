Airrecord.api_key = ENV["AIRTABLE_API_KEY"]

class Data < Airrecord::Table
  self.base_key = "app4qabxTnO0vDgdI"
  self.table_name = "data"
end