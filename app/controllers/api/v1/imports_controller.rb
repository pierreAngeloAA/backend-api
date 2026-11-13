class Api::V1::ImportsController < ApplicationController
  before_action :set_import, only: [ :show, :errors ]

  def create
    import = Import.new(file: params[:file])

    if import.save
      Imports::ProcessCsvJob.perform_async(import.id)
      render json: import, status: :created
    else
      render json: { errors: import.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { id: @import.id, status: @import.status, errors_count: @import.error_report.to_s.lines.count }
  end

  def errors
    if @import.error_report.present?
      send_data @import.error_report, filename: "import_#{@import.id}_errors.txt"
    else
      render json: { message: "No errors found" }
    end
  end

private

  def set_import
    @import = Import.find(params[:id])
  end
end
