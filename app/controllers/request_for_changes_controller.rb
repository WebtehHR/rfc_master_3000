class RequestForChangesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_request_for_change, only: [:show, :edit, :update, :destroy]

  # GET /request_for_changes
  # GET /request_for_changes.json
  def index
    @request_for_changes = RequestForChange.all
  end

  # GET /request_for_changes/1
  # GET /request_for_changes/1.json
  def show
  end

  # GET /request_for_changes/new
  def new
    @request_for_change = RequestForChange.new(requestor: current_user)
  end

  # POST /request_for_changes
  # POST /request_for_changes.json
  def create
    @request_for_change = RequestForChange.new(request_for_change_params.merge(requestor: current_user))

    respond_to do |format|
      if @request_for_change.save
        format.html { redirect_to edit_request_for_change_path(@request_for_change), notice: 'Request for change was successfully created.' }
        format.json { render action: 'show', status: :created, location: @request_for_change }
      else
        format.html { render action: 'new' }
        format.json { render json: @request_for_change.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /request_for_changes/1/edit
  def edit
    @request_for_change.set_manager(force: true)
    @request_for_change.set_security_officer(force: true)
  end

  # PATCH/PUT /request_for_changes/1
  # PATCH/PUT /request_for_changes/1.json
  def update
    @request_for_change.set_manager(force: true)
    @request_for_change.set_security_officer(force: true)

    respond_to do |format|
      if @request_for_change.update(request_for_change_params)
        format.html { redirect_to edit_request_for_change_path(@request_for_change), notice: 'Request for change was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @request_for_change.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request_for_change
      @request_for_change = RequestForChange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_for_change_params
      rfc = @request_for_change || RequestForChange.new
      
      safe_params = []
      safe_params += RequestForChange::REQUEST_ATTRIBUTES if rfc.request_section_editable?
      safe_params += RequestForChange::MANAGEMENT_APPROVAL_ATTRIBUTES if rfc.management_section_editable?
      safe_params += RequestForChange::SECURITY_APPROVAL_ATTRIBUTES if rfc.security_officer_section_editable?
      safe_params += RequestForChange::IMPLEMENTOR_ATTRIBUTES if rfc.implementation_section_editable?

      params.require(:request_for_change).permit(*safe_params)
    end
end
