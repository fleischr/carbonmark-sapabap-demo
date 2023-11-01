CLASS zcl_klima_smartcontract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_klima_smartcontract .

    METHODS constructor .
  PROTECTED SECTION.
    DATA: mo_prvd_api_helper    TYPE REF TO zcl_prvd_api_helper,
          mo_prvd_nchain_helper TYPE REF TO zcl_prvd_nchain_helper,
          mo_http_client        TYPE REF TO if_http_client,
          mo_nchain_api         TYPE REF TO zcl_prvd_nchain.
  PRIVATE SECTION.
    METHODS: get_nchain_helper RETURNING VALUE(ro_prvd_nchain_helper) TYPE REF TO zcl_prvd_nchain_helper.
ENDCLASS.



CLASS zcl_klima_smartcontract IMPLEMENTATION.


  METHOD constructor.
  ENDMETHOD.


  METHOD zif_klima_smartcontract~retirecarbon.
    DATA: lv_retirecarbon_params TYPE string.
    me->zif_klima_smartcontract~get_retirecarbon_params_string( EXPORTING iv_sourcetoken = iv_sourcetoken
                                                                          iv_pooltoken = iv_pooltoken
                                                                          iv_amount = iv_amount
                                                                          iv_amount_in_carbon = iv_amount_in_carbon
                                                                          iv_beneficiaryaddress = iv_beneficiaryaddress
                                                                          iv_beneficiarystring = iv_beneficiarystring
                                                                          iv_retirementmessage = iv_retirementmessage
                                                                IMPORTING ev_params_string = lv_retirecarbon_params ).

    "create the wallet
    DATA: ls_pricefeedwallet            TYPE zif_prvd_nchain=>ty_createhdwalletrequest,
          lv_getwallet_str              TYPE string,
          lv_getwallet_data             TYPE REF TO data,
          lv_getwallet_responsecode     TYPE i,
          ls_wallet_created             TYPE zif_prvd_nchain=>ty_hdwalletcreate_resp,
          ls_selectedcontract           TYPE zif_prvd_nchain=>ty_chainlinkpricefeed_req,
          lv_createdcontract_str        TYPE string,
          lv_createdcontract_data       TYPE REF TO data,
          lv_createdcontract_responsecd TYPE i,
          ls_executecontract            TYPE zif_prvd_nchain=>ty_executecontractrequest,
          lv_executecontract_str        TYPE string,
          lv_executecontract_xstr       TYPE xstring,
          lv_executecontract_data       TYPE REF TO data,
          lv_executecontract_responsecd TYPE i,
          lv_network_contract_id        TYPE zprvd_smartcontract_addr,
          lv_prvd_stack_contract_id     TYPE zcasesensitive_str,
          ls_execute_contract_resp      TYPE zif_prvd_nchain=>ty_executecontract_resp,
          ls_execute_contract_summary   TYPE zif_prvd_nchain=>ty_executecontract_summary.

    "Replace this part with a call to vault for existing wallet
    ls_pricefeedwallet-purpose = 44.
    mo_nchain_api->zif_prvd_nchain~createhdwallet( EXPORTING is_walletrequest    = ls_pricefeedwallet
                                                     IMPORTING ev_apiresponsestr   = lv_getwallet_str
                                                               ev_apiresponse      = lv_getwallet_data
                                                               ev_httpresponsecode = lv_getwallet_responsecode ).

    CASE lv_getwallet_responsecode.
      WHEN 201.
        /ui2/cl_json=>deserialize( EXPORTING json = lv_getwallet_str
                                    CHANGING data = ls_wallet_created ).
      WHEN OTHERS.
        "add error handling
    ENDCASE.
    "https://docs.klimadao.finance/developers/guides/retirement-aggregator-contract-guide
    "TransparentUpgradeableProxy needs to replace EACAggregatorProxy
    mo_prvd_nchain_helper->smartcontract_factory( EXPORTING iv_smartcontractaddress = '0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8'
                                     iv_name                 = 'KlimaRetirementAggregator'
                                     iv_walletaddress        = ls_wallet_created-id
                                     iv_nchain_networkid     = '4251b6fd-c98d-4017-87a3-d691a77a52a7'
                                     iv_contracttype         = 'TransparentUpgradeableProxy'
                           IMPORTING es_selectedcontract = ls_selectedcontract ).
    "may instead be zif_prvd_nchain~getcontractdetail
    mo_nchain_api->zif_prvd_nchain~createpricefeedcontract(
      EXPORTING
        iv_smartcontractaddr = '0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8'
        is_pricefeedcontract = ls_selectedcontract
      IMPORTING
        ev_apiresponsestr    = lv_createdcontract_str
        ev_apiresponse       = lv_createdcontract_data
        ev_httpresponsecode  = lv_createdcontract_responsecd ).
    CASE lv_createdcontract_responsecd.
      WHEN 201.

        FIELD-SYMBOLS: <fs_prvd_stack_contractid>     TYPE any,
                       <fs_prvd_stack_contractid_str> TYPE string.

        IF lv_createdcontract_data IS NOT INITIAL.
          ASSIGN lv_createdcontract_data->* TO FIELD-SYMBOL(<ls_contractdata>).
          IF sy-subrc <> 0.
          ENDIF.
          ASSIGN COMPONENT 'ID' OF STRUCTURE <ls_contractdata> TO <fs_prvd_stack_contractid>.
          IF sy-subrc <> 0.
          ENDIF.
          ASSIGN <fs_prvd_stack_contractid>->* TO <fs_prvd_stack_contractid_str>.
          IF sy-subrc <> 0.
          ENDIF.
          lv_prvd_stack_contract_id = <fs_prvd_stack_contractid_str>.
        ENDIF.
        ls_executecontract-method = 'retireCarbon'.
        ls_executecontract-value = 0.
        ls_executecontract-wallet_id = ls_wallet_created-id.
      WHEN 404.
        "contract not found - might not be deployed
      WHEN OTHERS.
    ENDCASE.
*
    mo_nchain_api->zif_prvd_nchain~executecontract(
      EXPORTING
        iv_contract_id      = lv_prvd_stack_contract_id
        is_execcontractreq  = ls_executecontract
      IMPORTING
        ev_apiresponsestr   = lv_executecontract_str
        ev_apiresponsexstr  = lv_executecontract_xstr
        ev_apiresponse      =  lv_executecontract_data
        ev_httpresponsecode =  lv_executecontract_responsecd ).
    CASE lv_executecontract_responsecd.
      WHEN 200.
        ls_execute_contract_summary-nchain_network_id = '4251b6fd-c98d-4017-87a3-d691a77a52a7'.
        ls_execute_contract_summary-prvd_stack_contractid = lv_prvd_stack_contract_id.
        ls_execute_contract_summary-smartcontract_addr = '0x0715A7794a1dc8e42615F059dD6e406A6594651A'.
        ls_execute_contract_summary-walletid = ls_wallet_created-id.
        "TODO - losing response values when deserializing. Round IDs surpass p8 type
        /ui2/cl_json=>deserialize( EXPORTING jsonx = lv_executecontract_xstr CHANGING data = ls_execute_contract_resp  ).
        ASSIGN lv_executecontract_data->* TO FIELD-SYMBOL(<ls_contractoutputs>).
        IF sy-subrc <> 0.
        ENDIF.
        ASSIGN COMPONENT 'RESPONSE' OF STRUCTURE <ls_contractoutputs> TO FIELD-SYMBOL(<fs_executecontract_resp>).
        IF sy-subrc <> 0.
        ENDIF.
        es_contract_resp = ls_execute_contract_resp.
        es_contract_summary = ls_execute_contract_summary.
      WHEN OTHERS.
    ENDCASE.



  ENDMETHOD.


  METHOD get_nchain_helper.
    IF mo_prvd_nchain_helper IS BOUND.
      ro_prvd_nchain_helper = mo_prvd_nchain_helper.
    ELSE.
      mo_prvd_api_helper->get_nchain_helper(
        IMPORTING
            eo_prvd_nchain_helper = ro_prvd_nchain_helper ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_klima_smartcontract~get_retirecarbon_params_string.
  ENDMETHOD.
ENDCLASS.
