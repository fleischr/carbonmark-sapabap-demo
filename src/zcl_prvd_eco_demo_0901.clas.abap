CLASS zcl_prvd_eco_demo_0901 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_demo_0901 .
    METHODS: constructor IMPORTING io_api_helper   TYPE REF TO zcl_prvd_api_helper
                                   io_vault_helper TYPE REF TO zcl_prvd_vault_helper.
    CLASS-METHODS: get_sflight_id IMPORTING iv_carrid            TYPE s_carr_id
                                            iv_connid            TYPE s_conn_id
                                            iv_fldat             TYPE s_date
                                  RETURNING VALUE(rv_sflight_id) TYPE string.
    METHODS: proof_of_atomic_offset IMPORTING is_atomic_offset TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset
                                              iv_subj_acct     TYPE zprvdtenantid
                                              iv_workgroupid   TYPE zprvdtenantid
                                              is_aggregate     TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010 OPTIONAL
                                              is_retirement    TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement OPTIONAL
                                    RETURNING VALUE(rs_bpiobj) TYPE zbpiobj.
    DATA: lcl_prvd_eco_ca_201x   TYPE REF TO zcl_prvd_eco_ca_201x,
          lcl_prvd_eco_cr_3030   TYPE REF TO zcl_prvd_eco_cr_3030,
          lcl_prvd_eco_ao_4010   TYPE REF TO zcl_prvd_eco_ao_4010,
          lcl_prvd_eco_poao_4200 TYPE REF TO zcl_prvd_eco_poao_4200.
  PROTECTED SECTION.
    DATA: mcl_prvd_api_helper   TYPE REF TO zcl_prvd_api_helper,
          mcl_prvd_vault_helper TYPE REF TO zcl_prvd_vault_helper,
          mv_access_token       TYPE zprvdrefreshtoken.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_demo_0901 IMPLEMENTATION.


  METHOD constructor.
    lcl_prvd_eco_ca_201x = NEW zcl_prvd_eco_ca_201x( ).
    lcl_prvd_eco_cr_3030 = NEW zcl_prvd_eco_cr_3030( ).
    lcl_prvd_eco_ao_4010 = NEW zcl_prvd_eco_ao_4010( ).
    lcl_prvd_eco_poao_4200 = NEW zcl_prvd_eco_poao_4200( ).
    mcl_prvd_api_helper = io_api_helper.
    mcl_prvd_vault_helper = io_vault_helper.
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~aggregate_sbook_emissions.
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~aggregate_sflight_emissions.

    CONSTANTS: c_carbon_per_seat TYPE zprvd_eco_carbontonne VALUE '0.0001'.
    DATA: ls_sflight      TYPE zi_prvd_eco_demo_0902,
          ls_aggr         TYPE zi_prvd_eco_ca_2010,
          lv_total_carbon TYPE zprvd_eco_carbontonne.

    "todo check the aggregate table if it exists alread

    SELECT SINGLE * FROM zi_prvd_eco_demo_0902 INTO @ls_sflight WHERE carrierid = @iv_carrid AND connectionid = @iv_connid AND flightdate = @iv_fldate.
    IF sy-subrc <> 0.
      "TODO throw error if none found
    ENDIF.

    SELECT SINGLE * FROM zi_prvd_eco_ca_2010 INTO @ls_aggr WHERE aggregateid = @ls_sflight-Sflight_ID.
    IF sy-subrc = 0.
      rs_sflight_carbon_aggregate-carrid = ls_sflight-CarrierID.
      rs_sflight_carbon_aggregate-connid = ls_sflight-ConnectionID.
      rs_sflight_carbon_aggregate-fldate = ls_sflight-FlightDate.
      rs_sflight_carbon_aggregate-carbon_amount = ls_aggr-CarbonAmount.
      rs_sflight_carbon_aggregate-carbon_uom = 'MT'.
    ELSE.
      "for demo purposes 100 kg per seat/hr, 3 hours
      lv_total_carbon = c_carbon_per_seat * ls_sflight-MaxSeatsEconomy * 3.
      rs_sflight_carbon_aggregate-carrid = ls_sflight-CarrierID.
      rs_sflight_carbon_aggregate-connid = ls_sflight-ConnectionID.
      rs_sflight_carbon_aggregate-fldate = ls_sflight-FlightDate.
      rs_sflight_carbon_aggregate-carbon_amount = lv_total_carbon.
      rs_sflight_carbon_aggregate-carbon_uom = 'MT'.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~create_atomic_offset.
    DATA: ls_atomic_offset TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset.
    ls_atomic_offset = lcl_prvd_eco_ao_4010->zif_prvd_eco_ao_4010~map_aggregate_and_retirement( is_aggregate = is_common_aggregate is_retirement = is_carbon_retirement ).
    lcl_prvd_eco_ao_4010->zif_prvd_eco_ao_4010~create( ls_atomic_offset ).
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~map_sbook_aggregate_to_2010.
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~map_sflight_aggregate_to_2010.
    DATA: lv_id TYPE string.
    lv_id = is_sflight_carbon_aggregate-carrid && '|' && is_sflight_carbon_aggregate-connid && '|' && is_sflight_carbon_aggregate-fldate.
    rs_common_aggregate-objnr = lv_id.
    rs_common_aggregate-aggregate_id = lv_id.
    rs_common_aggregate-objid = 'SFLIGHT'.
    rs_common_aggregate-carbon_amount = is_sflight_carbon_aggregate-carbon_amount.
    rs_common_aggregate-carbon_uom = is_sflight_carbon_aggregate-carbon_uom.
  ENDMETHOD.

  METHOD zif_prvd_eco_demo_0901~save_aggregate.
    lcl_prvd_eco_ca_201x->zif_prvd_eco_ca_2010~create( is_carbon_aggregate = is_carbon_aggregate ).
  ENDMETHOD.

  METHOD zif_prvd_eco_demo_0901~retire_carbon_from_aggregate.
*   iv_nchain_network_id type zprvd_nchain_networkid
*                                                  iv_vault_id type zprvdvaultid
*                                                  iv_source_token type zprvd_smartcontract_addr
*                                                  iv_pool_token type zprvd_smartcontract_addr
*                                                  iv_Beneficiary_Address type zprvd_smartcontract_addr
*                                                  iv_beneficiary_string type zcasesensitive_str
*                                                  iv_retirement_message type zcasesensitive_str

    DATA: lcl_prvd_bookie_eco         TYPE REF TO zcl_prvd_bookie_eco,
          li_client                   TYPE REF TO if_http_client,
          lv_bookie_host              TYPE string,
          lv_access_token             TYPE zprvdrefreshtoken,
          ls_bookie_eco_retire_carbon TYPE zif_prvd_bookie_eco=>ty_klima_retire_carbon_req,
          lv_httpresponsecd           TYPE i,
          lv_httpresponsedata         TYPE REF TO data,
          lv_httpresponsestr          TYPE string,
          ls_carbon_retirement        TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement,
          ls_signed_message           TYPE zif_prvd_vault=>ty_signed_message,
          lv_tx_hash                  TYPE zprvdtxnhash.

    lv_bookie_host = 'https://api.providepayments.com'.

    cl_http_client=>create_by_url(
      EXPORTING
      url                = lv_bookie_host
    IMPORTING
      client             = li_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).
    IF sy-subrc <> 0.
      " error handling
    ENDIF.

    li_client->propertytype_accept_cookie = if_http_client=>co_enabled.
    li_client->request->set_header_field( name  = if_http_form_fields_sap=>sap_client
                                               value = '100' ).

    mv_access_token = mcl_prvd_vault_helper->get_access_token( ).


    lcl_prvd_bookie_eco = NEW zcl_prvd_bookie_eco( ii_client = li_client iv_bookie_host = lv_bookie_host iv_accesstoken = mv_access_token ).



    ls_bookie_eco_retire_carbon-beneficiary_address = iv_beneficiary_address.
    ls_bookie_eco_retire_carbon-beneficiary_name = iv_beneficiary_string.
    ls_bookie_eco_retire_carbon-description = iv_retirement_message.
    ls_bookie_eco_retire_carbon-retirement_message = iv_retirement_message.
    ls_bookie_eco_retire_carbon-network_id = iv_nchain_network_id.
    ls_bookie_eco_retire_carbon-pool_token_contract_address = iv_pool_token.
    ls_bookie_eco_retire_carbon-project_token_contract_address = iv_project_token.
    ls_bookie_eco_retire_carbon-source_token_contract_address = iv_source_token.
    ls_bookie_eco_retire_carbon-value = is_common_aggregate-carbon_amount.
    ls_bookie_eco_retire_carbon-retire_by = 'carbon'.
    ls_bookie_eco_retire_carbon-max_source_bid = '1.00'.

    "! multiple carbon marketplaces can be supported
    "ls_bookie_eco_retire_carbon-provider = 'celo'.
    "ls_bookie_eco_retire_carbon-vault_key_id = iv_vault_key_id.
    "ls_bookie_eco_retire_carbon-vault_id = iv_vault_id.

    "paramaterize carbon retirement
    lcl_prvd_bookie_eco->zif_prvd_bookie_eco~parameters_retire_carbon_klima(
      EXPORTING
        is_carbon_retirement = ls_bookie_eco_retire_carbon
            IMPORTING
              ev_apiresponsestr    = lv_httpresponsestr
              ev_apiresponse       = lv_httpresponsedata
              ev_httpresponsecode  = lv_httpresponsecd ).

    CASE lv_httpresponsecd.
      WHEN 201.

        DATA: ls_bookie_eco_resp TYPE zif_prvd_bookie_eco=>ty_klima_retire_carbon_resp.

        DATA lif_ajson TYPE REF TO zif_ajson.
        lif_ajson = zcl_ajson=>parse( lv_httpresponsestr ).

        "TODO set this
        ls_signed_message-message = lif_ajson->get_string( '/hashed_data' ).
        DATA: lv_rawdata TYPE string.
        lv_rawdata = lif_ajson->get_string( '/data' ).

      WHEN OTHERS.
      "TODO add error here
    ENDCASE.

    "send txn to vault for signing
    DATA: ls_signature TYPE zif_prvd_vault=>ty_signature.
    ls_signature = mcl_prvd_vault_helper->sign( iv_vault_id = iv_vault_id
                                                iv_key_id   = iv_vault_key_id
                                                is_message  = ls_signed_message ).

    DATA: ls_calldata TYPE zif_prvd_bookie_eco=>ty_signed_data.
    ls_calldata-signature = ls_signature-signature.
    ls_calldata-data = lv_rawdata.
    ls_calldata-request_id = lif_ajson->get_string( '/id' ).
    ls_calldata-signer = iv_beneficiary_address.

    DATA: lv_httpresponsecd_2   TYPE i,
          lv_httpresponsedata_2 TYPE REF TO data,
          lv_httpresponsestr_2  TYPE string.

    "send to provide payments
    lcl_prvd_bookie_eco->zif_prvd_bookie_eco~retire_carbon_klima(
      EXPORTING
        is_signature        = ls_calldata
      IMPORTING
        ev_apiresponsestr   = lv_httpresponsestr_2
        ev_apiresponse      = lv_httpresponsedata_2
        ev_httpresponsecode = lv_httpresponsecd_2    ).

    CASE lv_httpresponsecd_2.
      WHEN 201.

        DATA: ls_nchain_resp TYPE zif_prvd_nchain=>ty_executecontract_resp.
        /ui2/cl_json=>deserialize( EXPORTING json = lv_httpresponsestr_2
                                   CHANGING  data = lv_httpresponsedata_2 ).

        DATA lif_ajson_retcarbon TYPE REF TO zif_ajson.
        lif_ajson_retcarbon = zcl_ajson=>parse( lv_httpresponsestr_2 ).

        lv_tx_hash = lif_ajson_retcarbon->get_string( '/tx_hash' ).

        ls_carbon_retirement-beneficiary_address_id = iv_beneficiary_address.
        ls_carbon_retirement-beneficiary_string_id = iv_beneficiary_string.
        ls_carbon_retirement-carbon_amount = is_common_aggregate-carbon_amount.
        ls_carbon_retirement-carbon_uom = 'MT'.
        ls_carbon_retirement-network_id = iv_nchain_network_id.
        ls_carbon_retirement-source_token = iv_source_token.
        ls_carbon_retirement-pool_token = iv_pool_token.
        ls_carbon_retirement-tx_hash = lv_tx_hash.
        ls_carbon_retirement-retirement_message_id = '1'.
        ls_carbon_retirement-beneficiary_string_id = '1'.
        ls_carbon_retirement-certificate_href = lif_ajson_retcarbon->get_string( '/certificate_href' ).
        lcl_prvd_eco_cr_3030->zif_prvd_eco_cr_3030~get_retirement_id(
          EXPORTING
            iv_network_id    = iv_nchain_network_id
            iv_txn_hash      =  lv_tx_hash
          IMPORTING
            ev_retirement_id = ls_carbon_retirement-retirement_id ).

        lcl_prvd_eco_cr_3030->zif_prvd_eco_cr_3030~create( is_carbon_retirement = ls_carbon_retirement  ).
        rs_carbon_retirement = ls_carbon_retirement.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~retire_carbon_sbook.
  ENDMETHOD.


  METHOD zif_prvd_eco_demo_0901~retire_carbon_sflight.
  ENDMETHOD.


  METHOD proof_of_atomic_offset.
    DATA: ls_poao   TYPE zif_prvd_eco_poao_4200=>ty_proof_of_atomic_offset,
          ls_bpiobj TYPE zbpiobj.
    ls_poao = lcl_prvd_eco_poao_4200->zif_prvd_eco_poao_4200~generate_poao( iv_atomic_offset_id = is_atomic_offset-atomic_offset_id
                                                                            is_atomic_offset = is_atomic_offset
                                                                            is_aggregate = is_aggregate
                                                                            is_retirement = is_retirement ).
    lcl_prvd_eco_poao_4200->zif_prvd_eco_poao_4200~emit_poao(
      EXPORTING
        is_poaoa    = ls_poao
        io_prvd_api_helper = mcl_prvd_api_helper
        iv_subj_acct = iv_subj_acct
        iv_workgroupid = iv_workgroupid
      IMPORTING
        es_poao_zkp = ls_bpiobj ).

    lcl_prvd_eco_poao_4200->zif_prvd_eco_poao_4200~save_proof(
      EXPORTING
        iv_atomic_offset_id = is_atomic_offset-atomic_offset_id
        is_poao_zkp         = ls_bpiobj ).

    rs_bpiobj = ls_bpiobj.

  ENDMETHOD.

  METHOD get_sflight_id.
    DATA: lv_sflight_id TYPE string.
    lv_sflight_id = iv_carrid && '|' && iv_connid && '|' && iv_fldat.
    rv_sflight_id = lv_sflight_id.
  ENDMETHOD.
ENDCLASS.
