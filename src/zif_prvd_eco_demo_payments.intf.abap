INTERFACE zif_prvd_eco_demo_payments
  PUBLIC .

  TYPES ty_sourcetoken TYPE zprvd_smartcontract_addr .
  TYPES ty_pooltoken TYPE zprvd_smartcontract_addr .
  TYPES ty_amount TYPE char80 .             "uint256
  TYPES ty_amount_in_carbon TYPE char1 .   "bool true/false
  TYPES ty_beneficiaryaddress TYPE zprvd_smartcontract_addr .
  TYPES ty_beneficiarystring TYPE string .
  TYPES ty_retirementmessage TYPE string .

  TYPES: BEGIN OF ty_klima_retire_carbon_req,
           network_id                    TYPE zprvd_nchain_networkid,
           "vault_id type zprvdvaultid,
           "vault_key_id type zprvdvaultid,
           description                   TYPE zcasesensitive_str,
           value                         TYPE zprvd_eco_carbontonne, " zprvd_eco_carbon_uint64,
           source_token_contract_address TYPE zprvd_smartcontract_addr,
           pool_token_contract_address   TYPE zprvd_smartcontract_addr,
           beneficiary_address           TYPE zprvd_smartcontract_addr,
           beneficiary_name              TYPE zcasesensitive_str,
           retirement_message            TYPE zcasesensitive_str,
         END OF ty_klima_retire_carbon_req.



  "parameterize retire carbon
  TYPES: BEGIN OF ty_klima_retire_carbon_resp,
           id                            TYPE string,
           network_id                    TYPE zprvd_nchain_networkid,
           "vault_id type zprvdvaultid,
           "vault_key_id type zprvdvaultid,
           description                   TYPE zcasesensitive_str,
           value                         TYPE zprvd_eco_carbontonne, " zprvd_eco_carbon_uint64,
           source_token_contract_address TYPE zprvd_smartcontract_addr,
           pool_token_contract_address   TYPE zprvd_smartcontract_addr,
           beneficiary_address           TYPE zprvd_smartcontract_addr,
           beneficiary_name              TYPE zcasesensitive_str,
           retirement_message            TYPE zcasesensitive_str,
         END OF ty_klima_retire_carbon_resp.



  "retire carbon
  TYPES: BEGIN OF ty_signed_data,
           "ref type string,
           data       TYPE string,
           request_id TYPE string,
           signature  TYPE string,
           signer     TYPE string,
           "network_id type zprvd_nchain_networkid,
         END OF ty_signed_data.


  METHODS: parameters_retire_carbon_klima IMPORTING !is_carbon_retirement TYPE ty_klima_retire_carbon_req
                                          EXPORTING !ev_apiresponsestr    TYPE string
                                                    !ev_apiresponse       TYPE REF TO data
                                                    !ev_httpresponsecode  TYPE i.

  METHODS: retire_carbon_klima IMPORTING !is_signature        TYPE zif_prvd_eco_demo_payments=>ty_signed_data
                               EXPORTING !ev_apiresponsestr   TYPE string
                                         !ev_apiresponse      TYPE REF TO data
                                         !ev_httpresponsecode TYPE i.

ENDINTERFACE.
