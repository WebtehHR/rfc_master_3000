class RequestForChangesController < ApplicationController
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
    @request_for_change = RequestForChange.new
  end

  # GET /request_for_changes/1/edit
  def edit
  end

  # POST /request_for_changes
  # POST /request_for_changes.json
  def create
    @request_for_change = RequestForChange.new(request_for_change_params)

    respond_to do |format|
      if @request_for_change.save
        format.html { redirect_to @request_for_change, notice: 'Request for change was successfully created.' }
        format.json { render action: 'show', status: :created, location: @request_for_change }
      else
        format.html { render action: 'new' }
        format.json { render json: @request_for_change.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_for_changes/1
  # PATCH/PUT /request_for_changes/1.json
  def update
    respond_to do |format|
      if @request_for_change.update(request_for_change_params)
        format.html { redirect_to @request_for_change, notice: 'Request for change was successfully updated.' }
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
      params.require(:request_for_change).permit(:noc_tracking_number, :webteh_tracking_number, :type_network, :type_servers, :type_application, :type_user_management, :requested_by_id, :description_of_change, :change_repair, :change_removal, :change_emergency, :change_other, :request_implement_window, :systems_affected, :users_affected, :criticality_of_change, :test_plan, :back_out_plan, :management_approver_id, :cso_approver_id, :approval_status, :approval_comments, :change_scheduled_for, :approval_date, :implementor_id, :implementation_status, :implement_comments, :implementation_start, :implementation_end)
    end
end
