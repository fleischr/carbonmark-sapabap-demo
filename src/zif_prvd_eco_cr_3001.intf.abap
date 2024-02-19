INTERFACE zif_prvd_eco_cr_3001
  PUBLIC .

  TYPES: BEGIN OF ty_prvd_eco_dest_contract,
           network_id  TYPE zprvd_nchain_networkid,
           provider    TYPE char10,
           contract    TYPE zprvd_smartcontract_addr,
           description TYPE char255,
         END OF ty_prvd_eco_dest_contract.

  class-methods: create IMPORTING is_dest_contract type ty_prvd_eco_dest_contract,
           read   IMPORTING iv_network_id type zprvd_nchain_networkid
                            iv_provider type char10
                            iv_contract type zprvd_smartcontract_addr
                  RETURNING VALUE(rv_dest_contract) type ty_prvd_eco_dest_contract,
           update IMPORTING is_dest_contract type ty_prvd_eco_dest_contract,
           delete IMPORTING iv_network_id type zprvd_nchain_networkid
                            iv_provider type char10
                            iv_contract type zprvd_smartcontract_addr,
           get_default IMPORTING iv_network_id type zprvd_nchain_networkid OPTIONAL
                       RETURNING VALUE(rv_dest_contract) type ty_prvd_eco_dest_contract.

ENDINTERFACE.
