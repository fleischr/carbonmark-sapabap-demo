*&---------------------------------------------------------------------*
*& Report zprovide_eco_demo_sflight
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprovide_eco_demo_sflight.

PARAMETERS: p_carrid TYPE s_carr_id,
            p_connid TYPE s_conn_id,
            p_fldat  TYPE s_date.

PARAMETERS: p_aggr TYPE char1 AS CHECKBOX,
            p_ao   TYPE char1 AS CHECKBOX,
            p_poao TYPE char1 AS CHECKBOX.

PARAMETERS: p_orgid  TYPE zprvdtenantid,
            p_subjid TYPE zprvdtenantid,
            p_wrkgrp TYPE zprvdtenantid.

PARAMETERS: P_netwrk TYPE zprvd_nchain_networkid,
            p_srctkn TYPE zprvd_smartcontract_addr,
            p_pltkn  TYPE zprvd_smartcontract_addr.



DATA: lcl_provide_eco_sflightdemo TYPE REF TO zcl_prvd_eco_demo_0901,
      lcl_prvd_api_helper         TYPE REF TO zcl_prvd_api_helper,
      lcl_prvd_vault_helper       TYPE REF TO zcl_prvd_vault_helper,
      ls_sflight                  TYPE zi_prvd_eco_demo_0902,
      ls_sflight_aggregate        TYPE zif_prvd_eco_demo_0901=>ty_sflight_carbon_aggregate,
      lv_carbon_aggregate_id      TYPE zprvd_eco_carbonaggregateid,
      ls_carbon_aggregate         TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
      ls_carbon_retirement        TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement,
      ls_carbon_atomicoffset      TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset.


INITIALIZATION.

START-OF-SELECTION.

  lcl_prvd_api_helper = NEW zcl_prvd_api_helper( iv_tenant = p_orgid iv_subject_acct_id = p_subjid iv_workgroup_id = p_wrkgrp ).
  lcl_prvd_vault_helper = NEW zcl_prvd_vault_helper( io_prvd_api_helper = lcl_prvd_api_helper ).
  lcl_provide_eco_sflightdemo = NEW zcl_prvd_eco_demo_0901( io_api_helper = lcl_prvd_api_helper io_vault_helper = lcl_prvd_vault_helper  ).

  SELECT SINGLE * FROM zi_prvd_eco_demo_0902 INTO @ls_sflight WHERE carrierid = @p_carrid AND connectionid = @p_connid AND flightdate = @p_fldat.
  IF sy-subrc <> 0.
  ELSE.
    lv_carbon_aggregate_id = ls_sflight-Sflight_ID.
  ENDIF.

  IF p_aggr = abap_true.


    ls_carbon_aggregate = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ca_201x->zif_prvd_eco_ca_2010~read( iv_aggregate_id = lv_carbon_aggregate_id ).
    IF ls_carbon_aggregate IS INITIAL.

      ls_sflight_aggregate = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~aggregate_sflight_emissions(
        EXPORTING
          iv_carrid                   = p_carrid
          iv_connid                   = p_connid
          iv_fldate                   = p_fldat
          iv_aggregatetype            = '' ).

      "aggregate the carbon footprint
      ls_carbon_aggregate = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~map_sflight_aggregate_to_2010( ls_sflight_aggregate ).

      lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~save_aggregate( is_carbon_aggregate = ls_carbon_aggregate  ).
    ENDIF.
  ENDIF.

  IF p_ao = abap_true.

    DATA: lv_vault_id       TYPE zprvdvaultid,
          lt_vault_list     TYPE zif_prvd_vault=>tty_vault_query,
          ls_vault          TYPE zif_prvd_vault=>ty_vault_query,
          lt_vault_key_list TYPE zif_prvd_vault=>ty_vault_keys_list,
          ls_vault_key      TYPE zif_prvd_vault=>ty_vault_keys,
          lv_vault_key_id   type zprvdvaultid.
    "retire the appropriate amount of carbon via KlimaDAO retirement aggregator
    lt_vault_list = lcl_prvd_vault_helper->list_vaults( ).
    READ TABLE lt_vault_list INDEX 1 INTO ls_vault.
    IF sy-subrc <> 0.
    ENDIF.
    lv_vault_id = ls_vault-id.

    lt_vault_key_list = lcl_prvd_vault_helper->list_keys( iv_vault_id = lv_vault_id ).
    READ TABLE lt_vault_key_list WITH KEY spec = 'secp256k1' INTO ls_vault_key.
    IF sy-subrc <> 0.
    ENDIF.
    DATA: lv_beneficiary_address TYPE zprvd_smartcontract_addr.
    lv_beneficiary_address = ls_vault_key-address.
    lv_vault_key_id = ls_vault_key-id.
    ls_carbon_retirement = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~retire_carbon_from_aggregate( is_common_aggregate  = ls_carbon_aggregate
                                                                                                             iv_nchain_network_id = p_netwrk
                                                                                                             iv_vault_id = lv_vault_id
                                                                                                             iv_vault_key_id = lv_vault_key_id
                                                                                                             iv_source_token = p_srctkn
                                                                                                             iv_pool_token = p_pltkn
                                                                                                             iv_Beneficiary_Address = lv_beneficiary_address
                                                                                                             iv_beneficiary_string = 'Provide SFLIGHT demo'
                                                                                                             iv_retirement_message = 'Provide SFLIGHT demo'  ).

    "prepare the atomic offset record
    ls_carbon_atomicoffset = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~create_atomic_offset( is_common_aggregate  = ls_carbon_aggregate
                                                                                                       is_carbon_retirement = ls_carbon_retirement ).
  ENDIF.

  IF p_poao = abap_true.

    "create proof of atomic offset
    lcl_provide_eco_sflightdemo->proof_of_atomic_offset( is_atomic_offset = ls_carbon_atomicoffset
                                                         is_aggregate = ls_carbon_aggregate
                                                         is_retirement = ls_carbon_retirement ).
  ENDIF.
