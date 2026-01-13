class Imports::ProcessCsvJob
  include Sidekiq::Job

  def perform(import_id)
    import = Import.find(import_id)

    import.update!(status: :processing)

    Imports::ProcessCsvService.new(import).call

    import.update!(status: :completed)
  rescue StandardError => e
    import.update!(status: :failed, error_report: e.message)
  end
end
