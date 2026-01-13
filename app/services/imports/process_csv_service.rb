require "csv"

class Imports::ProcessCsvService
  def initialize(import)
    @import = import
    @errors = []
  end

  def call
    CSV.foreach(@import.file.path, headers: true).with_index(2) do |row, line|
      begin
        customer = Customer.find_or_initialize_by(document: row["document"])
        puts "ROW => #{row.inspect}"
        customer.update!(
          full_name: row["full_name"],
          email: row["email"],
          phone: row["phone"]
        )
      rescue StandardError => e
        @errors << "Line #{line}: #{e.message}"
      end
    end

    if @errors.any?
      @import.update!(error_report: @errors.join("\n"))
    end
  end
end
