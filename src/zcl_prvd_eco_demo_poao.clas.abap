CLASS zcl_prvd_eco_demo_poao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_poao_4200 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_demo_poao IMPLEMENTATION.


  METHOD zif_prvd_eco_poao_4200~emit_poao.
    DATA: lv_setup_success     TYPE boolean,
          ls_protocol_msg_req  TYPE zif_prvd_baseline=>protocolmessage_req,
          ls_protocol_msg_resp TYPE zif_prvd_baseline=>protocolmessage_resp,
          lv_status            TYPE i,
          lv_apiresponse       TYPE REF TO data,
          lv_apiresponsestr    TYPE string,
          ls_poao_data         TYPE REF TO data,
          mo_prvd_api_helper   TYPE REF TO zcl_prvd_api_helper.

    "o_prvd_api_helper->setup_protocol_msg( IMPORTING setup_success = lv_setup_success ).

    GET REFERENCE OF is_poaoa INTO ls_poao_data.

    "request to /api/v1/protocol_messages
    ls_protocol_msg_req-payload = ls_poao_data.
    ls_protocol_msg_req-payload_mimetype = 'json'.
    ls_protocol_msg_req-type = 'AtomicOffset'.
    ls_protocol_msg_req-subject_account_id = iv_subj_acct.
    ls_protocol_msg_req-workgroup_id = iv_workgroupid.

    ls_protocol_msg_req-id = is_poaoa-atomic_offset_id.

    io_prvd_api_helper->setup_protocol_msg( ).

    io_prvd_api_helper->send_protocol_msg( EXPORTING is_body           = ls_protocol_msg_req
                                                     iv_subj_acct      = iv_subj_acct
                                                     iv_workgroup_id    = iv_workgroupid
                                           IMPORTING ev_statuscode     = lv_status
                                                     ev_apiresponse    = lv_apiresponse
                                                     ev_apiresponsestr = lv_apiresponsestr ).
    CASE lv_status.
      WHEN 202.
        /ui2/cl_json=>deserialize( EXPORTING json = lv_apiresponsestr
                                    CHANGING data = ls_protocol_msg_resp ).

        DATA: wa_bpiobj    TYPE zbpiobj,
              lv_timestamp TYPE timestampl.
        GET TIME STAMP FIELD lv_timestamp.
        wa_bpiobj-mandt = sy-mandt.
        wa_bpiobj-baseline_id = ls_protocol_msg_resp-baseline_id.
        wa_bpiobj-proof = ls_protocol_msg_resp-proof.
        wa_bpiobj-object_id = ls_protocol_msg_req-id.
        wa_bpiobj-changed_by = sy-uname.
        wa_bpiobj-changed_at = lv_timestamp.
        wa_bpiobj-schematype = 'DDIC'.
        wa_bpiobj-schema_id = 'AtomicOffset'.
        wa_bpiobj-workgroup_id = ls_protocol_msg_resp-workgroup_id.
        wa_bpiobj-subject_account_id = ls_protocol_msg_resp-subject_account_id.
        es_poao_zkp = wa_bpiobj.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD zif_prvd_eco_poao_4200~generate_poao.

    DATA: ls_atomic_offset TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset,
          ls_aggregate     TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
          ls_retirement    TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement,
          ls_proof_ao      TYPE zif_prvd_eco_poao_4200=>ty_proof_of_atomic_offset.

    IF is_atomic_offset IS NOT INITIAL.
      ls_atomic_offset = is_atomic_offset.
    ELSE.
    ENDIF.
    IF is_aggregate IS NOT INITIAL.
      ls_aggregate = is_aggregate.
    ELSE.
    ENDIF.
    IF is_retirement IS NOT INITIAL.
      ls_retirement = is_retirement.
    ELSE.
    ENDIF.

    ls_proof_ao-aggregate_id = ls_aggregate-aggregate_id.
    ls_proof_ao-atomic_offset_id = ls_atomic_offset-atomic_offset_id.
    ls_proof_ao-carbon_uom = ls_retirement-carbon_uom.
    ls_proof_ao-network_id = ls_retirement-network_id.
    "ls_proof_ao-object_list
    ls_proof_ao-retirement_id = ls_retirement-retirement_id.
    ls_proof_ao-total_carbon_aggregate = ls_atomic_offset-atomic_offset_amount.
    ls_proof_ao-tx_hash = ls_retirement-tx_hash.
    ls_proof_ao-sor_type = 'SAP'.
    ls_proof_ao-object_key = ls_aggregate-objnr.
    ls_proof_ao-object_type = ls_aggregate-objid .

    rs_poao = ls_proof_ao.


  ENDMETHOD.


  METHOD zif_prvd_eco_poao_4200~save_proof.
    MODIFY zbpiobj FROM is_poao_zkp.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
