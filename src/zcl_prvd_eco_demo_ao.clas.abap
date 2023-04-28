CLASS zcl_prvd_eco_demo_ao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_ao_4010 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_demo_ao IMPLEMENTATION.


  METHOD zif_prvd_eco_ao_4010~calculate_offset_factor.
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~create.
    DATA: ls_atomic_offset TYPE zprvdeco4010.
    ls_atomic_offset-client = sy-mandt.
    ls_atomic_offset-aggregate_id = is_atomic_offset-aggregate_id.
    ls_atomic_offset-retirement_id = is_atomic_offset-retirement_id.
    ls_atomic_offset-atomic_offset_id = is_atomic_offset-atomic_offset_id.
    ls_atomic_offset-atomic_offset_amount = is_atomic_offset-atomic_offset_amount.
    ls_atomic_offset-atomic_offset_uom = is_atomic_offset-atomic_offset_uom.
    ls_atomic_offset-objid = is_atomic_offset-objid.
    ls_atomic_offset-objnr = is_atomic_offset-objnr.
    MODIFY zprvdeco4010 FROM ls_atomic_offset.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~delete.
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~map_aggregate_and_retirement.
    rs_atomic_offset-objid = is_aggregate-objid.
    rs_atomic_offset-objnr = is_aggregate-objnr.
    rs_atomic_offset-aggregate_id = is_aggregate-aggregate_id.
    rs_atomic_offset-atomic_offset_amount = is_retirement-carbon_amount.
    rs_atomic_offset-retirement_id = is_retirement-retirement_id.
    rs_atomic_offset-atomic_offset_uom = is_retirement-carbon_uom.
    rs_atomic_offset-atomic_offset_id = zif_prvd_eco_ao_4010~generate_atomic_offset_id( iv_aggregate_id = is_aggregate-aggregate_id iv_retirement_id = is_retirement-retirement_id ).
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~query.
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~read.
  ENDMETHOD.


  METHOD zif_prvd_eco_ao_4010~update.
  ENDMETHOD.

  METHOD zif_prvd_eco_ao_4010~generate_atomic_offset_id.
    DATA lo_digest TYPE REF TO cl_abap_message_digest.
    DATA lv_hash_string TYPE string.

* create a message digest object with a given hash algo
    lo_digest = cl_abap_message_digest=>get_instance( 'sha256' ).

    lo_digest->update( if_data = cl_abap_message_digest=>string_to_xstring( |{ iv_aggregate_id }| ) ).
    lo_digest->update( if_data = cl_abap_message_digest=>string_to_xstring( |{ iv_retirement_id }| ) ).

    lo_digest->digest( ).

    lv_hash_string = lo_digest->to_string( ).
    rv_atomic_offset_id = lv_hash_string.
  ENDMETHOD.
ENDCLASS.
