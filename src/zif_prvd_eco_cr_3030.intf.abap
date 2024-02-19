INTERFACE zif_prvd_eco_cr_3030
  PUBLIC .

  TYPES: BEGIN OF ty_carbon_retirement,
           retirement_id          TYPE zprvd_eco_carbonretirementid,
           network_id             TYPE zprvd_nchain_networkid,
           tx_hash               TYPE zprvdtxnhash,
           source_token           TYPE zprvd_nchain_token_abbr,
           pool_token             TYPE zprvd_nchain_token_abbr,
           carbon_amount          TYPE zprvd_eco_carbontonne,
           carbon_uom             TYPE meins,
           beneficiary_address_id TYPE zprvd_smartcontract_addr,
           beneficiary_string_id  TYPE zcasesensitive_str,
           retirement_message_id  TYPE zcasesensitive_str,
           certificate_href       type zprvd_eco_certurl,
           retirement_index       type int4,
         END OF ty_carbon_retirement.


  METHODS: create IMPORTING is_carbon_retirement TYPE ty_carbon_retirement,
        read IMPORTING iv_retirement_id          TYPE zprvd_eco_carbonretirementid
             RETURNING VALUE(rs_carbon_retirement) type zprvdeco3030,
        update IMPORTING is_carbon_retirement TYPE ty_carbon_retirement,
        delete IMPORTING iv_retirement_id  TYPE zprvd_eco_carbonretirementid,
        query IMPORTING iv_retirement_id          TYPE zprvd_eco_carbonretirementid
                        iv_network_id             TYPE zprvd_nchain_networkid
                        iv_txn_hash               TYPE zprvdtxnhash
                        iv_source_token           TYPE zprvd_nchain_token_abbr
                        iv_pool_token             TYPE zprvd_nchain_token_abbr
                        iv_carbon_amount          TYPE zprvd_eco_carbontonne
                        iv_carbon_uom             TYPE meins
                        iv_beneficiary_address_id TYPE char20
                        iv_beneficiary_string_id  TYPE char20
                        iv_retirement_message_id  TYPE char20.

  METHODS: get_retirement_id IMPORTING iv_network_id    TYPE zprvd_nchain_networkid
                                       iv_txn_hash         TYPE zprvdtxnhash
                             EXPORTING ev_retirement_id TYPE zprvd_eco_carbonretirementid.

  METHODS: retire_carbon_klima IMPORTING iv_payment_channel        TYPE char1
                                         iv_network_id             TYPE zprvd_nchain_networkid
                                         iv_source_token           TYPE zprvd_nchain_token_abbr
                                         iv_pool_token             TYPE zprvd_nchain_token_abbr
                                         iv_carbon_amount          TYPE zprvd_eco_carbontonne
                                         iv_carbon_uom             TYPE meins
                                         iv_beneficiary_address_id TYPE char20
                                         iv_beneficiary_string_id  TYPE char20
                                         iv_retirement_message_id  TYPE char20
                               EXPORTING ev_txn_hash type zprvdtxnhash.
  "! TODO remove unused method
  class-METHODS: carbontonne_to_uint64 IMPORTING iv_carbon_amount type zprvd_eco_carbontonne
                                                 iv_token_type type zprvd_nchain_token_abbr
                                       RETURNING VALUE(rv_carbon_amount_uint64) type zprvd_eco_carbon_uint64.

  METHODS: get_next_retirement_index IMPORTING iv_beneficiary_address_id type zprvd_smartcontract_addr
                                               iv_network_id type zprvd_nchain_networkid
                                     RETURNING VALUE(rv_next_retirement_index) type int4.

ENDINTERFACE.
