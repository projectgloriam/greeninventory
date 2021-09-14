require 'test_helper'

class EquipmentControllerTest < ActionController::TestCase
  setup do
    @equipment = equipment(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:equipment)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create equipment" do
    assert_difference('Equipment.count') do
      post :create, equipment: { customer_Warranty_end: @equipment.customer_Warranty_end, customer_Warranty_start: @equipment.customer_Warranty_start, date: @equipment.date, engineer: @equipment.engineer, equipment_name: @equipment.equipment_name, job_sheet_number: @equipment.job_sheet_number, model: @equipment.model, specification_id: @equipment.specification_id, supplier: @equipment.supplier, supplier_Warranty_end: @equipment.supplier_Warranty_end, supplier_Warranty_start: @equipment.supplier_Warranty_start, supplier_invoice_number: @equipment.supplier_invoice_number }
    end

    assert_redirected_to equipment_path(assigns(:equipment))
  end

  test "should show equipment" do
    get :show, id: @equipment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @equipment
    assert_response :success
  end

  test "should update equipment" do
    patch :update, id: @equipment, equipment: { customer_Warranty_end: @equipment.customer_Warranty_end, customer_Warranty_start: @equipment.customer_Warranty_start, date: @equipment.date, engineer: @equipment.engineer, equipment_name: @equipment.equipment_name, job_sheet_number: @equipment.job_sheet_number, model: @equipment.model, specification_id: @equipment.specification_id, supplier: @equipment.supplier, supplier_Warranty_end: @equipment.supplier_Warranty_end, supplier_Warranty_start: @equipment.supplier_Warranty_start, supplier_invoice_number: @equipment.supplier_invoice_number }
    assert_redirected_to equipment_path(assigns(:equipment))
  end

  test "should destroy equipment" do
    assert_difference('Equipment.count', -1) do
      delete :destroy, id: @equipment
    end

    assert_redirected_to equipment_index_path
  end
end
