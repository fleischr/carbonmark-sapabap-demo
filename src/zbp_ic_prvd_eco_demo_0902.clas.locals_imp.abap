CLASS lhc_ZIC_PRVD_ECO_DEMO_0902 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zic_prvd_eco_demo_0902 RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zic_prvd_eco_demo_0902 RESULT result.

    METHODS aggregateCarbon FOR MODIFY
      IMPORTING keys FOR ACTION zic_prvd_eco_demo_0902~aggregateCarbon RESULT result.

    METHODS proofOfAtomicOffset FOR MODIFY
      IMPORTING keys FOR ACTION zic_prvd_eco_demo_0902~proofOfAtomicOffset RESULT result.

    METHODS retireCarbon FOR MODIFY
      IMPORTING keys FOR ACTION zic_prvd_eco_demo_0902~retireCarbon RESULT result.

ENDCLASS.

CLASS lhc_ZIC_PRVD_ECO_DEMO_0902 IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD aggregateCarbon.
    DATA:
      lv_carbon_aggregate_id      TYPE zprvd_eco_carbonaggregateid,
      lcl_provide_eco_sflightdemo TYPE REF TO zcl_prvd_eco_demo_0901,
      lcl_prvd_api_helper         TYPE REF TO zcl_prvd_api_helper,
      lcl_prvd_vault_helper       TYPE REF TO zcl_prvd_vault_helper,
      ls_sflight_aggregate        TYPE zif_prvd_eco_demo_0901=>ty_sflight_carbon_aggregate,
      ls_carbon_aggregate         TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
      lv_carrid                   TYPE s_carr_id,
      lv_connid                   TYPE s_conn_id,
      lv_fldat                    TYPE s_date.

    lcl_prvd_api_helper = NEW zcl_prvd_api_helper( ).
    lcl_prvd_vault_helper = NEW zcl_prvd_vault_helper( io_prvd_api_helper = lcl_prvd_api_helper ).
    lcl_provide_eco_sflightdemo = NEW zcl_prvd_eco_demo_0901( io_api_helper = lcl_prvd_api_helper io_vault_helper = lcl_prvd_vault_helper  ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.
    IF sy-subrc = 0.
      lv_carrid = <fs_keys>-CarrierID.
      lv_connid = <fs_keys>-ConnectionID.
      lv_fldat  = <fs_keys>-FlightDate.
    ELSE.
      "todo handle error
    ENDIF.
    lv_carbon_aggregate_id = zcl_prvd_eco_demo_0901=>get_sflight_id( iv_carrid = lv_carrid iv_connid = lv_connid iv_fldat  = lv_fldat ).

    ls_carbon_aggregate = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ca_201x->zif_prvd_eco_ca_2010~read( iv_aggregate_id = lv_carbon_aggregate_id ).
    IF ls_carbon_aggregate IS INITIAL.

      ls_sflight_aggregate = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~aggregate_sflight_emissions(
        EXPORTING
          iv_carrid                   = lv_carrid
          iv_connid                   = lv_connid
          iv_fldate                   = lv_fldat
          iv_aggregatetype            = '' ).

      "aggregate the carbon footprint
      ls_carbon_aggregate = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~map_sflight_aggregate_to_2010( ls_sflight_aggregate ).

      lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~save_aggregate( is_carbon_aggregate = ls_carbon_aggregate  ).
    ENDIF.

    "   READ ENTITIES OF /DMO/I_Travel_M IN LOCAL MODE
    "  ENTITY travel
    "    FIELDS ( begin_date end_date )
    "    WITH CORRESPONDING #( keys )
    "  RESULT DATA(travels)

*    MODIFY ENTITIES OF zic_prvd_eco_demo_0902 IN LOCAL MODE ENTITY zic_prvd_eco_demo_0902
*    UPDATE FIELDS ( hasCarbonAggregate )
*    WITH VALUE #( FOR key IN keys ( %tky = key-%tky hasCarbonAggregate = 'X' ) )
*    FAILED failed
*    REPORTED reported.
*    "read the result
*     "Read changed data for action result
    READ ENTITIES OF zic_prvd_eco_demo_0902 IN LOCAL MODE
      ENTITY zic_prvd_eco_demo_0902
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(flights).

    result = VALUE #( FOR flight IN flights
             ( %tky   = flight-%tky
               %param = flight ) ).


  ENDMETHOD.

  METHOD proofOfAtomicOffset.
    DATA:
      lv_carbon_aggregate_id      TYPE zprvd_eco_carbonaggregateid,
      lcl_provide_eco_sflightdemo TYPE REF TO zcl_prvd_eco_demo_0901,
      lcl_carbon_ao               TYPE REF TO zcl_prvd_eco_ao_4010,
      lcl_carbon_agg              TYPE REF TO zcl_prvd_eco_ca_201x,
      lcl_carbon_cr               TYPE REF TO zcl_prvd_eco_cr_3030,
      lcl_prvd_api_helper         TYPE REF TO zcl_prvd_api_helper,
      lcl_prvd_vault_helper       TYPE REF TO zcl_prvd_vault_helper,
      ls_carbon_atomicoffset      TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset,
      ls_carbon_aggregate         TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
      ls_carbon_retirement        TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement,
      lv_tenant                   TYPE zprvdtenantid,
      lv_subject_acct_id          TYPE zprvdtenantid,
      lv_workgroup_id             TYPE zprvdtenantid,
      lv_carrid                   TYPE s_carr_id,
      lv_connid                   TYPE s_conn_id,
      lv_fldat                    TYPE s_date.

    "ls_carbon_atomicoffset = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ao_4010->zif_prvd_eco_ao_4010~read( '' ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.
    IF sy-subrc = 0.
      lv_carrid = <fs_keys>-CarrierID.
      lv_connid = <fs_keys>-ConnectionID.
      lv_fldat  = <fs_keys>-FlightDate.
    ELSE.
      "todo handle error
    ENDIF.
    lv_carbon_aggregate_id = zcl_prvd_eco_demo_0901=>get_sflight_id( iv_carrid = lv_carrid iv_connid = lv_connid iv_fldat  = lv_fldat ).

    lcl_prvd_api_helper = NEW zcl_prvd_api_helper( ).
    lcl_prvd_vault_helper = NEW zcl_prvd_vault_helper( io_prvd_api_helper = lcl_prvd_api_helper ).
    lcl_provide_eco_sflightdemo = NEW zcl_prvd_eco_demo_0901( io_api_helper = lcl_prvd_api_helper io_vault_helper = lcl_prvd_vault_helper  ).


    ls_carbon_aggregate = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ca_201x->zif_prvd_eco_ca_2010~read( lv_carbon_aggregate_id  ).
    SELECT SINGLE * FROM zprvdeco4010 INTO CORRESPONDING FIELDS OF ls_carbon_atomicoffset WHERE aggregate_id = lv_carbon_aggregate_id.
    SELECT SINGLE * FROM zprvdeco3030 INTO CORRESPONDING FIELDS OF ls_carbon_retirement WHERE retirement_id = ls_carbon_atomicoffset-retirement_id.
    "ls_carbon_atomicoffset = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ao_4010->zif_prvd_eco_ao_4010~query( iv_aggregate_id = lv_carbon_aggregate_id )
    "ls_carbon_retirement = lcl_provide_eco_sflightdemo->lcl_prvd_eco_cr_3030->zif_prvd_eco_cr_3030~read( )



    "create proof of atomic offset
    lcl_provide_eco_sflightdemo->proof_of_atomic_offset( is_atomic_offset = ls_carbon_atomicoffset
                                                         is_aggregate = ls_carbon_aggregate
                                                         is_retirement = ls_carbon_retirement
                                                         iv_subj_acct = lv_subject_acct_id
                                                         iv_workgroupid = lv_workgroup_id ).

    READ ENTITIES OF zic_prvd_eco_demo_0902 IN LOCAL MODE
      ENTITY zic_prvd_eco_demo_0902
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(flights).

    result = VALUE #( FOR flight IN flights
             ( %tky   = flight-%tky
               %param = flight ) ).
  ENDMETHOD.

  METHOD retireCarbon.
    DATA:
      lv_carbon_aggregate_id      TYPE zprvd_eco_carbonaggregateid,
      lcl_provide_eco_sflightdemo TYPE REF TO zcl_prvd_eco_demo_0901,
      lcl_prvd_api_helper         TYPE REF TO zcl_prvd_api_helper,
      lcl_prvd_vault_helper       TYPE REF TO zcl_prvd_vault_helper,
      ls_sflight_aggregate        TYPE zif_prvd_eco_demo_0901=>ty_sflight_carbon_aggregate,
      ls_carbon_aggregate         TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
      lv_carrid                   TYPE s_carr_id,
      lv_connid                   TYPE s_conn_id,
      lv_fldat                    TYPE s_date,
      ls_carbon_retirement        TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement,
      lv_network_id               TYPE zprvd_nchain_networkid,
      lv_sourcetoken              TYPE zprvd_smartcontract_addr,
      lv_pooltoken                TYPE zprvd_smartcontract_addr.

    lcl_prvd_api_helper = NEW zcl_prvd_api_helper( ).
    lcl_prvd_vault_helper = NEW zcl_prvd_vault_helper( io_prvd_api_helper = lcl_prvd_api_helper ).
    lcl_provide_eco_sflightdemo = NEW zcl_prvd_eco_demo_0901( io_api_helper = lcl_prvd_api_helper io_vault_helper = lcl_prvd_vault_helper  ).

    DATA: lv_vault_id       TYPE zprvdvaultid,
          lt_vault_list     TYPE zif_prvd_vault=>tty_vault_query,
          ls_vault          TYPE zif_prvd_vault=>ty_vault_query,
          lt_vault_key_list TYPE zif_prvd_vault=>ty_vault_keys_list,
          ls_vault_key      TYPE zif_prvd_vault=>ty_vault_keys,
          lv_vault_key_id   TYPE zprvdvaultid.
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

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.
    IF sy-subrc = 0.
      lv_carrid = <fs_keys>-CarrierID.
      lv_connid = <fs_keys>-ConnectionID.
      lv_fldat  = <fs_keys>-FlightDate.
    ELSE.
      "todo handle error
    ENDIF.
    lv_carbon_aggregate_id = zcl_prvd_eco_demo_0901=>get_sflight_id( iv_carrid = lv_carrid iv_connid = lv_connid iv_fldat  = lv_fldat ).

    ls_carbon_aggregate = lcl_provide_eco_sflightdemo->lcl_prvd_eco_ca_201x->zif_prvd_eco_ca_2010~read( lv_carbon_aggregate_id  ).


    DATA: ls_token_defaults TYPE zif_prvd_eco_cr_3000=>ty_defaults.

    ls_token_defaults = zcl_prvd_eco_cr_3000=>zif_prvd_eco_cr_3000~get_defaults('2fd61fde-5031-41f1-86b8-8a72e2945ead').

    ls_carbon_retirement = lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~retire_carbon_from_aggregate( is_common_aggregate  = ls_carbon_aggregate
                                                                                                             iv_nchain_network_id = ls_token_defaults-network_id
                                                                                                             iv_vault_id = lv_vault_id
                                                                                                             iv_vault_key_id = lv_vault_key_id
                                                                                                             iv_source_token = ls_token_defaults-source_token_addr
                                                                                                             iv_pool_token = ls_token_defaults-pool_token_addr
                                                                                                             iv_project_token = '0x5e9ff0805e4fcf16ba0cc268c404e34c2fecf101'
                                                                                                             iv_Beneficiary_Address = lv_beneficiary_address
                                                                                                             iv_beneficiary_string = 'Carbonmark API - Provide ABAP SFLIGHT Fiori demo'
                                                                                                             iv_retirement_message = 'Carbonmark API - Provide ABAP SFLIGHT Fiori demo.'  ).

    lcl_provide_eco_sflightdemo->zif_prvd_eco_demo_0901~create_atomic_offset( is_common_aggregate  = ls_carbon_aggregate
                                                                              is_carbon_retirement = ls_carbon_retirement ).

    READ ENTITIES OF zic_prvd_eco_demo_0902 IN LOCAL MODE
     ENTITY zic_prvd_eco_demo_0902
     ALL FIELDS WITH
     CORRESPONDING #( keys )
     RESULT DATA(flights).

    result = VALUE #( FOR flight IN flights
             ( %tky   = flight-%tky
               %param = flight ) ).


  ENDMETHOD.

ENDCLASS.
