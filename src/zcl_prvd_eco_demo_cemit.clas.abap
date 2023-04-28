CLASS zcl_prvd_eco_demo_cemit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_ca_2010 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_demo_cemit IMPLEMENTATION.


  METHOD zif_prvd_eco_ca_2010~create.
    DATA: ls_prvd_eco_2010 TYPE zprvdeco2010.
    ls_prvd_eco_2010-client = sy-mandt.
    ls_prvd_eco_2010-aggregate_id = is_carbon_aggregate-aggregate_id.
    ls_prvd_eco_2010-carbon_amount = is_carbon_aggregate-carbon_amount.
    ls_prvd_eco_2010-carbon_uom = is_carbon_aggregate-carbon_uom.
    ls_prvd_eco_2010-objid = is_carbon_aggregate-objid.
    ls_prvd_eco_2010-objnr = is_carbon_aggregate-objnr.
    MODIFY zprvdeco2010 FROM ls_prvd_eco_2010.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_ca_2010~delete.
    data: ls_carbon_aggregate type zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010.
    ls_carbon_aggregate = me->zif_prvd_eco_ca_2010~read(
      EXPORTING
        iv_aggregate_id     = iv_aggregate_id
*      RECEIVING
*        rs_carbon_aggregate =
    ).
    delete from zprvdeco2010 where aggregate_id = ls_carbon_aggregate-aggregate_id.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_ca_2010~query.
  ENDMETHOD.


  METHOD zif_prvd_eco_ca_2010~read.
    SELECT SINGLE * FROM zprvdeco2010 INTO CORRESPONDING FIELDS OF rs_carbon_aggregate WHERE aggregate_id = iv_aggregate_id.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_ca_2010~update.
  ENDMETHOD.


ENDCLASS.
