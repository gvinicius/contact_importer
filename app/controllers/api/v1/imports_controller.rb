class Api::V1::ImportsController < ApiController
  def create
    import = Import.new(user: current_user)
    import.sheet.attach(io: File.open("#{Rails.root}/spec/fixtures/sheet.csv"), filename: 'sheet.csv', content_type: 'text/csv')
    import.save
    import.run
    if import.status == :terminated
      render :index, status: :created
    else
      render json: import, status: :unprocessable_entity
    end
  end

  def index
    render json: Import.where(user: current_user)
  end
end
