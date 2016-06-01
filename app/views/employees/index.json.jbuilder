json.array!(@employees) do |employee|
  json.extract! employee, :id, :company_id, :first_name, :last_name, :work_as, :date_of_employment
  json.url employee_url(employee, format: :json)
end
