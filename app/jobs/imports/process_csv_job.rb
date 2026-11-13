class Imports::ProcessCsvJob
  include Sidekiq::Job

  def perform(import_id)
    # The import can be deleted while the job waits in the queue: nothing to do.
    import = Import.find_by(id: import_id)
    return if import.nil?

    import.update!(status: :processing)

    Imports::ProcessCsvService.new(import).call

    import.update!(status: :completed)
  rescue StandardError => e
    import.update!(status: :failed, error_report: e.message)
  end
end
