INTERFACE zif_prvd_eco_demo_token
  PUBLIC .

  TYPES: BEGIN OF ty_sourcepool_token_config,
           network_id    TYPE zprvd_nchain_networkid,
           token_address TYPE zprvd_smartcontract_addr,
           token_abbr    TYPE zprvd_nchain_token_abbr,
           token_desc    TYPE zcasesensitive_str,
           token_type    TYPE zprvd_eco_klima_tokentype,
         END OF ty_sourcepool_token_config.

  TYPES: BEGIN OF ty_defaults,
           network_id        TYPE zprvd_nchain_networkid,
           source_token_addr TYPE zprvd_smartcontract_addr,
           pool_token_addr   TYPE zprvd_smartcontract_addr,
         END OF ty_defaults.

  TYPES: ty_sourcepool_token_list TYPE TABLE OF ty_sourcepool_token_config WITH KEY network_id token_address.

  CLASS-METHODS create IMPORTING is_sourcepool_token_config TYPE ty_sourcepool_token_config .
  CLASS-METHODS read IMPORTING iv_network_id               TYPE zprvd_nchain_networkid
                               iv_token_address            TYPE zprvd_smartcontract_addr
                     RETURNING VALUE(rs_sourcepool_config) TYPE ty_sourcepool_token_config.
  CLASS-METHODS update IMPORTING is_sourcepool_token_config TYPE ty_sourcepool_token_config .
  CLASS-METHODS delete IMPORTING iv_network_id    TYPE zprvd_nchain_networkid
                                 iv_token_address TYPE zprvd_smartcontract_addr .
  CLASS-METHODS query IMPORTING iv_network_id                   TYPE zprvd_nchain_networkid
                                iv_token_address                TYPE zprvd_smartcontract_addr
                                iv_token_abbr                   TYPE zprvd_nchain_token_abbr
                                iv_token_desc                   TYPE zcasesensitive_str
                                iv_token_type                   TYPE zprvd_eco_klima_tokentype
                      RETURNING VALUE(rt_sourcepool_token_list) TYPE ty_sourcepool_token_list.
  CLASS-METHODS get_defaults IMPORTING iv_network_id      TYPE zprvd_nchain_networkid OPTIONAL
                             RETURNING VALUE(rs_defaults) TYPE ty_defaults.
ENDINTERFACE.
