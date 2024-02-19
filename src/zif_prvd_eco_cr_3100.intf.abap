INTERFACE zif_prvd_eco_cr_3100
  PUBLIC .

  TYPES: BEGIN OF ty_prvd_eco_cl_pricefeed,
           contract_address TYPE zprvd_smartcontract_addr,
           network_id       TYPE zprvd_nchain_networkid,
           pair_id          TYPE char10,
           from_token       TYPE zprvd_nchain_token_abbr,
           to_token         TYPE zprvd_nchain_token_abbr,
           description      TYPE char255,
         END OF ty_prvd_eco_cl_pricefeed.

  TYPES: BEGIN OF ty_latestrounddata_result,
           roundid         TYPE int8,
           answer          TYPE int8,
           startedat       TYPE int8,
           updatedat       TYPE int8,
           answeredinround TYPE int8,
         END OF ty_latestrounddata_result.

  TYPES: BEGIN OF ty_mapped_rounddata_result,
           roundid             TYPE int8,
           formatted_answer    TYPE ukurs,
           formatted_currency  TYPE waers_curc,
           formatted_startedat TYPE timestampl,
           formatted_updatedat TYPE timestampl,
           answeredinround     TYPE int8,
         END OF ty_mapped_rounddata_result.

  TYPES: ty_prvd_eco_cl_pricefeed_list TYPE TABLE OF ty_prvd_eco_cl_pricefeed WITH KEY contract_address network_id.

  METHODS: create IMPORTING is_eco_pricefeed TYPE ty_prvd_eco_cl_pricefeed,
    read IMPORTING iv_contract_address     TYPE zprvd_smartcontract_addr
                   iv_network_id           TYPE zprvd_nchain_networkid
         RETURNING VALUE(rs_eco_pricefeed) TYPE ty_prvd_eco_cl_pricefeed,
    update IMPORTING is_eco_pricefeed TYPE ty_prvd_eco_cl_pricefeed,
    delete IMPORTING iv_contract_address TYPE zprvd_smartcontract_addr
                     iv_network_id       TYPE zprvd_nchain_networkid,
    query RETURNING VALUE(rt_eco_pricefeed) TYPE ty_prvd_eco_cl_pricefeed_list,
    get_latest_pf_result IMPORTING iv_contract_address          TYPE zprvd_smartcontract_addr
                                   iv_network_id                TYPE zprvd_nchain_networkid
                         RETURNING VALUE(rs_latestround_result) TYPE ty_latestrounddata_result,
    map_pf_result IMPORTING is_latestrounddata         TYPE ty_latestrounddata_result
                            iv_inputcurrency           TYPE  waers_curc
                  RETURNING VALUE(rs_mapped_rounddata) TYPE ty_mapped_rounddata_result.

ENDINTERFACE.
