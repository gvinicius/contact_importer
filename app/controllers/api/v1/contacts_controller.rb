class Api::V1::ContactsController < ApplicationController
  def index
    render json: Contact.where(user: current_user).collect{ |item| item.prepared_contact }
  end
end
