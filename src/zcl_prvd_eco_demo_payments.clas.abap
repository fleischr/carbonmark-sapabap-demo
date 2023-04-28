CLASS zcl_prvd_eco_demo_payments DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: c_retire_carbon TYPE string VALUE '/api/v1/eco/retire_carbon_requests/{id}/retire',
               c_retire_carbon_params type string value '/api/v1/eco/retire_carbon_requests'.
    INTERFACES zif_prvd_eco_demo_payments .
    METHODS: constructor IMPORTING ii_client      TYPE REF TO if_http_client
                                   iv_bookie_host TYPE zcasesensitive_str
                                   iv_accesstoken TYPE zprvdrefreshtoken.
  PROTECTED SECTION.
    DATA: mi_client       TYPE REF TO if_http_client,
          mv_bookie_host  TYPE string,
          mv_access_token TYPE zprvdrefreshtoken.
    METHODS: get_bearer_token.
    METHODS: send_receive RETURNING VALUE(rv_code) TYPE i.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_demo_payments IMPLEMENTATION.

  METHOD constructor.
    mi_client = ii_client.
    mv_bookie_host = iv_bookie_host.
    mv_access_token = iv_accesstoken.
  ENDMETHOD.

  METHOD zif_prvd_eco_demo_payments~parameters_retire_carbon_klima.
    DATA lv_code TYPE i.
    DATA lv_temp TYPE string.
    DATA lv_retire_carbon_req_str TYPE string.
    DATA lv_retire_carbon_req_data TYPE REF TO data.
    DATA lv_responsestr TYPE string.
    mi_client->request->set_method( 'POST' ).
    mi_client->request->set_header_field( name = '~request_uri'
                                         value = c_retire_carbon_params ).
    get_bearer_token( ).

    zcl_prvd_api_helper=>copy_data_to_ref( EXPORTING is_data = is_carbon_retirement
                                           CHANGING cr_data = lv_retire_carbon_req_data  ).

    lv_retire_carbon_req_str = /ui2/cl_json=>serialize( data =  lv_retire_carbon_req_data
                                                        pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    mi_client->request->set_cdata( data = lv_retire_carbon_req_str ).

    lv_code = send_receive( ).
    "WRITE / lv_code. ~ replace with logging call

    ev_httpresponsecode = lv_code.
    lv_responsestr = mi_client->response->get_cdata( ).
    ev_apiresponsestr = lv_responsestr.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_responsestr
      CHANGING
        data = ev_apiresponse ).
    CASE lv_code.
      WHEN 200.
        " The request was successful
      WHEN OTHERS.
        " Request was not successful
    ENDCASE.
  ENDMETHOD.

  method zif_prvd_eco_demo_payments~retire_carbon_klima.
    DATA lv_code TYPE i.
    DATA lv_temp TYPE string.
    DATA lv_retire_carbon_req_str TYPE string.
    DATA lv_retire_carbon_req_data TYPE REF TO data.
    DATA lv_responsestr TYPE string.
    lv_temp = c_retire_carbon.
    replace all OCCURRENCES OF '{id}' in lv_temp with is_signature-request_id.
    mi_client->request->set_method( 'POST' ).
    mi_client->request->set_header_field( name = '~request_uri'
                                         value = lv_temp ).
    get_bearer_token( ).

    zcl_prvd_api_helper=>copy_data_to_ref( EXPORTING is_data = is_signature
                                           CHANGING cr_data = lv_retire_carbon_req_data  ).

    lv_retire_carbon_req_str = /ui2/cl_json=>serialize( data =  lv_retire_carbon_req_data
                                                        pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    mi_client->request->set_cdata( data = lv_retire_carbon_req_str ).

    lv_code = send_receive( ).
    "WRITE / lv_code. ~ replace with logging call

    ev_httpresponsecode = lv_code.
    lv_responsestr = mi_client->response->get_cdata( ).
    ev_apiresponsestr = lv_responsestr.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_responsestr
      CHANGING
        data = ev_apiresponse ).
    CASE lv_code.
      WHEN 200.
        " The request was successful
      WHEN OTHERS.
        " Request was not successful
    ENDCASE.
  ENDMETHOD.

  METHOD get_bearer_token.
    DATA lv_bearertoken TYPE string.
    "todo check auth token is valid (not empty or expired)
    CONCATENATE 'Bearer' mv_access_token INTO lv_bearertoken SEPARATED BY space.
    mi_client->request->set_header_field( name  = 'Authorization' value = lv_bearertoken ).
  ENDMETHOD.

  METHOD send_receive.
    mi_client->send( EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2 ).
    IF sy-subrc = 0.
      mi_client->receive( EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3 ).
      IF sy-subrc NE 0.
        rv_code = 500.
      ENDIF.
    ELSE.
      rv_code = 500.
    ENDIF.
    mi_client->response->get_status( IMPORTING code = rv_code ).
  ENDMETHOD.

ENDCLASS.
