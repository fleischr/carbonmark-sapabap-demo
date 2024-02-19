CLASS zcl_prvd_eco_cr_3001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_cr_3001 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_cr_3001 IMPLEMENTATION.


  METHOD zif_prvd_eco_cr_3001~create.
    DATA: ls_dest_contract TYPE zprvdeco3001.
    MOVE-CORRESPONDING is_dest_contract TO ls_dest_contract.
    ls_dest_contract-client = sy-mandt.
    MODIFY zprvdeco3001 FROM ls_dest_contract.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3001~delete.
    DELETE from zprvdeco3001 WHERE network_id = iv_network_id
                          AND    provider = iv_provider
                          AND contract =    iv_contract.
    IF sy-subrc <> 0.
    ENDIF.

  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3001~get_default.
    if iv_network_id is not INITIAL.
       " select zprvdeco3001 into CORRESPONDING FIELDS OF rv_dest_contract
       "    where network_id = iv_network_id
       "     up to 1 rows .
    else.
    endif.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3001~read.

  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3001~update.
    DATA: ls_dest_contract TYPE zprvdeco3001.
    MOVE-CORRESPONDING is_dest_contract TO ls_dest_contract.
    ls_dest_contract-client = sy-mandt.
    MODIFY zprvdeco3001 FROM ls_dest_contract.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
