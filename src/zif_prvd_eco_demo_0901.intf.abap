INTERFACE zif_prvd_eco_demo_0901
  PUBLIC .

  TYPES: BEGIN OF ty_sflight_carbon_aggregate,
           carrid        TYPE s_carr_id,
           connid        TYPE s_conn_id,
           fldate        TYPE s_date,
           carbon_amount TYPE zprvd_eco_carbontonne,
           carbon_uom    TYPE meins,
         END OF ty_sflight_carbon_aggregate.

  TYPES: BEGIN OF ty_sbook_carbon_aggregate,
           carrid        TYPE s_carr_id,
           connid        TYPE s_conn_id,
           fldate        TYPE s_date,
           bookid        TYPE s_book_id,
           carbon_amount TYPE zprvd_eco_carbontonne,
           carbon_uom    TYPE meins,
         END OF ty_sbook_carbon_aggregate.


  METHODS: aggregate_sflight_emissions IMPORTING iv_carrid                          TYPE s_carr_id
                                                 iv_connid                          TYPE s_conn_id
                                                 iv_fldate                          TYPE s_date
                                                 iv_aggregatetype                   TYPE char1
                                       RETURNING VALUE(rs_sflight_carbon_aggregate) TYPE ty_sflight_carbon_aggregate.
  METHODS: map_sflight_aggregate_to_2010 IMPORTING is_sflight_carbon_aggregate TYPE ty_sflight_carbon_aggregate
                                         RETURNING VALUE(rs_common_aggregate)  TYPE zif_prvd_eco_demo_crem=>ty_carbon_aggregate_ca2010.
  METHODS: map_sbook_aggregate_to_2010 IMPORTING is_sbook_carbon_aggregate  TYPE ty_sbook_carbon_aggregate
                                       RETURNING VALUE(rs_common_aggregate) TYPE zif_prvd_eco_demo_crem=>ty_carbon_aggregate_ca2010.
  METHODS: aggregate_sbook_emissions IMPORTING iv_carrid                        TYPE s_carr_id
                                               iv_connid                        TYPE s_conn_id
                                               iv_fldate                        TYPE s_date
                                               iv_bookid                        TYPE s_book_id
                                     RETURNING VALUE(rs_sbook_carbon_aggregate) TYPE ty_sbook_carbon_aggregate.
  METHODS: save_aggregate IMPORTING is_carbon_aggregate TYPE zif_prvd_eco_demo_crem=>ty_carbon_aggregate_ca2010.
  METHODS: retire_carbon_from_aggregate IMPORTING is_common_aggregate         TYPE zif_prvd_eco_demo_crem=>ty_carbon_aggregate_ca2010
                                                  iv_nchain_network_id        TYPE zprvd_nchain_networkid
                                                  iv_vault_id                 TYPE zprvdvaultid
                                                  iv_vault_key_id             TYPE zprvdvaultid
                                                  iv_source_token             TYPE zprvd_smartcontract_addr
                                                  iv_pool_token               TYPE zprvd_smartcontract_addr
                                                  iv_Beneficiary_Address      TYPE zprvd_smartcontract_addr
                                                  iv_beneficiary_string       TYPE zcasesensitive_str
                                                  iv_retirement_message       TYPE zcasesensitive_str
                                        RETURNING VALUE(rs_carbon_retirement) TYPE zif_prvd_eco_demo_cret=>ty_carbon_retirement.
  METHODS: retire_carbon_sflight IMPORTING is_sflight_carbon_aggregate TYPE ty_sflight_carbon_aggregate.
  METHODS: retire_carbon_sbook IMPORTING is_sbook_carbon_aggregate TYPE ty_sflight_carbon_aggregate.
  METHODS: create_atomic_offset IMPORTING is_common_aggregate     TYPE zif_prvd_eco_demo_crem=>ty_carbon_aggregate_ca2010
                                          is_carbon_retirement    TYPE zif_prvd_eco_demo_cret=>ty_carbon_retirement
                                RETURNING VALUE(rs_atomic_offset) TYPE zif_prvd_eco_demo_AO=>ty_atomic_offset.


ENDINTERFACE.
