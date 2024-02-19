CLASS zcl_prvd_eco_cr_3030 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor.
    INTERFACES zif_prvd_eco_cr_3030 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_cr_3030 IMPLEMENTATION.

  METHOD constructor.
  ENDMETHOD.

  METHOD zif_prvd_eco_cr_3030~create.
    DATA: ls_prvd_eco_3030 TYPE zprvdeco3030.
    ls_prvd_eco_3030-mandt = sy-mandt.
    ls_prvd_eco_3030-retirement_id =  is_carbon_retirement-retirement_id.
    ls_prvd_eco_3030-network_id =       is_carbon_retirement-network_id.
    ls_prvd_eco_3030-tx_hash =       is_carbon_retirement-tx_hash.
    ls_prvd_eco_3030-source_token =       is_carbon_retirement-source_token.
    ls_prvd_eco_3030-pool_token =       is_carbon_retirement-pool_token.
    ls_prvd_eco_3030-carbon_amount =       is_carbon_retirement-carbon_amount.
    ls_prvd_eco_3030-carbon_uom =       is_carbon_retirement-carbon_uom.
    ls_prvd_eco_3030-beneficiary_address_id =       is_carbon_retirement-beneficiary_address_id.
    ls_prvd_eco_3030-beneficiary_string_id =       is_carbon_retirement-beneficiary_string_id.
    ls_prvd_eco_3030-retirement_message_id =       is_carbon_retirement-retirement_message_id.
    ls_prvd_eco_3030-certificate_href   = is_carbon_retirement-certificate_href.
    ls_prvd_eco_3030-retirement_index = me->zif_prvd_eco_cr_3030~get_next_retirement_index( iv_beneficiary_address_id = is_carbon_retirement-beneficiary_address_id
                                                                                            iv_network_id = is_carbon_retirement-network_id ).
    MODIFY zprvdeco3030 FROM ls_prvd_eco_3030.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~delete.
    DELETE FROM zprvdeco3030 WHERE retirement_id = iv_retirement_id.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~get_retirement_id.
    DATA lo_digest TYPE REF TO cl_abap_message_digest.
    DATA lv_hash_string TYPE string.

* create a message digest object with a given hash algo
    lo_digest = cl_abap_message_digest=>get_instance( 'sha256' ).

    lo_digest->update( if_data = cl_abap_message_digest=>string_to_xstring( |{ iv_network_id }| ) ).
    lo_digest->update( if_data = cl_abap_message_digest=>string_to_xstring( |{ iv_txn_hash }| ) ).

    lo_digest->digest( ).

    lv_hash_string = lo_digest->to_string( ).
    ev_retirement_id = lv_hash_string.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~query.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~read.
    SELECT SINGLE * FROM zprvdeco3030 INTO @rs_carbon_retirement WHERE retirement_id = @iv_retirement_id.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~retire_carbon_klima.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3030~update.
    DATA: ls_prvd_eco_3030_x TYPE zprvdeco3030,
          ls_prvd_eco_3030_y TYPE zprvdeco3030.

    ls_prvd_eco_3030_x =  me->zif_prvd_eco_cr_3030~read( is_carbon_retirement-retirement_id ).
    ls_prvd_eco_3030_y-retirement_id =  is_carbon_retirement-retirement_id.
    ls_prvd_eco_3030_y-network_id = is_carbon_retirement-network_id.
    ls_prvd_eco_3030_y-tx_hash =       is_carbon_retirement-tx_hash.
    ls_prvd_eco_3030_y-source_token =       is_carbon_retirement-source_token.
    ls_prvd_eco_3030_y-pool_token =       is_carbon_retirement-pool_token.
    ls_prvd_eco_3030_y-carbon_amount =       is_carbon_retirement-carbon_amount.
    ls_prvd_eco_3030_y-carbon_uom =       is_carbon_retirement-carbon_uom.
    ls_prvd_eco_3030_y-beneficiary_address_id =       is_carbon_retirement-beneficiary_address_id.
    ls_prvd_eco_3030_y-beneficiary_string_id =       is_carbon_retirement-beneficiary_string_id.
    ls_prvd_eco_3030_y-retirement_message_id =       is_carbon_retirement-retirement_message_id.
    ls_prvd_eco_3030_y-certificate_href = is_carbon_retirement-certificate_href.

    IF ls_prvd_eco_3030_y-network_id IS INITIAL.
      ls_prvd_eco_3030_y-network_id = ls_prvd_eco_3030_x-network_id.
    ENDIF.
    IF ls_prvd_eco_3030_y-tx_hash IS INITIAL.
      ls_prvd_eco_3030_y-tx_hash = ls_prvd_eco_3030_x-tx_hash.
    ENDIF.
    IF ls_prvd_eco_3030_y-source_token IS INITIAL.
      ls_prvd_eco_3030_y-source_token = ls_prvd_eco_3030_x-source_token.
    ENDIF.
    IF ls_prvd_eco_3030_y-pool_token IS INITIAL.
      ls_prvd_eco_3030_y-pool_token = ls_prvd_eco_3030_x-pool_token.
    ENDIF.
    IF ls_prvd_eco_3030_y-carbon_amount IS INITIAL.
      ls_prvd_eco_3030_y-carbon_amount = ls_prvd_eco_3030_x-carbon_amount.
    ENDIF.
    IF ls_prvd_eco_3030_y-carbon_uom IS INITIAL.
      ls_prvd_eco_3030_y-carbon_uom = ls_prvd_eco_3030_x-carbon_uom.
    ENDIF.
    IF ls_prvd_eco_3030_y-beneficiary_address_id IS INITIAL.
      ls_prvd_eco_3030_y-beneficiary_address_id = ls_prvd_eco_3030_x-beneficiary_address_id.
    ENDIF.
    IF ls_prvd_eco_3030_y-beneficiary_string_id IS INITIAL.
      ls_prvd_eco_3030_y-beneficiary_string_id = ls_prvd_eco_3030_x-beneficiary_string_id.
    ENDIF.
    IF ls_prvd_eco_3030_y-retirement_index IS INITIAL.
      ls_prvd_eco_3030_y-retirement_index = ls_prvd_eco_3030_x-retirement_index.
    ENDIF.
    IF ls_prvd_eco_3030_y-certificate_href IS INITIAL.
      ls_prvd_eco_3030_y-certificate_href = ls_prvd_eco_3030_x-certificate_href.
    ENDIF.


    MODIFY zprvdeco3030 FROM ls_prvd_eco_3030_y.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.

  METHOD zif_prvd_eco_cr_3030~carbontonne_to_uint64.
    DATA: lv_carbon_uint64 TYPE zprvd_eco_carbon_uint64,
          lv_carbon_float  TYPE float.

    lv_carbon_float = iv_carbon_amount * 1000000000.
    lv_carbon_uint64 = lv_carbon_float.
    rv_carbon_amount_uint64 = lv_carbon_uint64.
  ENDMETHOD.

  METHOD zif_prvd_eco_cr_3030~get_next_retirement_index.
    SELECT MAX( retirement_index ) FROM zprvdeco3030 INTO @DATA(lv_retirement_index) WHERE beneficiary_address_id = @iv_beneficiary_address_id
                                                                                       AND network_id = @iv_network_id.
    IF sy-subrc = 0.
      rv_next_retirement_index = lv_retirement_index + 1.
    ELSE.
      rv_next_retirement_index = 1.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
