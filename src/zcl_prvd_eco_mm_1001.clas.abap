CLASS zcl_prvd_eco_mm_1001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_mm_1001 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_mm_1001 IMPLEMENTATION.


  METHOD zif_prvd_eco_mm_1001~create.
    DATA: ls_prvdeco1001 TYPE zprvdeco1001.
    ls_prvdeco1001 = zif_prvd_eco_mm_1001~map_to_zprvdeco1001( is_carbon_emission ).
    MODIFY zprvdeco1001 FROM ls_prvdeco1001.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~delete.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~map_from_zprvdeco1001.
    rs_carbon_emission_mm1001-material = is_zprvdeco1001-matnr.
    rs_carbon_emission_mm1001-plant = is_zprvdeco1001-werks.
    rs_carbon_emission_mm1001-valid_to = is_zprvdeco1001-valid_to.
    rs_carbon_emission_mm1001-valid_from = is_zprvdeco1001-valid_from.
    rs_carbon_emission_mm1001-carbon_amount = is_zprvdeco1001-carbon_amount.
    rs_carbon_emission_mm1001-carbon_uom = is_zprvdeco1001-carbon_uom.
    rs_carbon_emission_mm1001-preferred_pool_token = is_zprvdeco1001-preferred_pool_token.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~map_to_zprvdeco1001.
    rs_zprvdeco1001-matnr = is_carbon_emission_mm1001-material.
    rs_zprvdeco1001-werks = is_carbon_emission_mm1001-plant.
    rs_zprvdeco1001-valid_to = is_carbon_emission_mm1001-valid_to.
    rs_zprvdeco1001-valid_from = is_carbon_emission_mm1001-valid_from.
    rs_zprvdeco1001-carbon_amount = is_carbon_emission_mm1001-carbon_amount.
    rs_zprvdeco1001-carbon_uom = is_carbon_emission_mm1001-carbon_uom.
    rs_zprvdeco1001-preferred_pool_token = is_carbon_emission_mm1001-preferred_pool_token.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~query.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~read.
  ENDMETHOD.


  METHOD zif_prvd_eco_mm_1001~update.
    DATA: ls_prvdeco1001 TYPE zprvdeco1001.
    ls_prvdeco1001 = zif_prvd_eco_mm_1001~map_to_zprvdeco1001( is_carbon_emission ).
    MODIFY zprvdeco1001 FROM ls_prvdeco1001.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
