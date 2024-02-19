CLASS zcl_prvd_eco_cr_3000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_prvd_eco_cr_3000 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_cr_3000 IMPLEMENTATION.


  METHOD zif_prvd_eco_cr_3000~create.
    DATA: ls_prvd_eco_cr_3000 TYPE zprvdeco3000.

    ls_prvd_eco_cr_3000-network_id = is_sourcepool_token_config-network_id.
    ls_prvd_eco_cr_3000-token_abbr = is_sourcepool_token_config-token_abbr.
    ls_prvd_eco_cr_3000-token_address = is_sourcepool_token_config-token_address.
    ls_prvd_eco_cr_3000-token_desc = is_sourcepool_token_config-token_desc.
    ls_prvd_eco_cr_3000-token_type = is_sourcepool_token_config-token_type.
    MODIFY zprvdeco3000 FROM ls_prvd_eco_cr_3000.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3000~delete.
    DELETE FROM zprvdeco3000 WHERE network_id = iv_network_id
                             AND token_address = iv_token_address.
    IF sy-subrc <> 0.
    ENDIF.

  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3000~query.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3000~read.
  ENDMETHOD.


  METHOD zif_prvd_eco_cr_3000~update.
    DATA: ls_prvd_eco_cr_3000 TYPE zprvdeco3000.

    ls_prvd_eco_cr_3000-network_id = is_sourcepool_token_config-network_id.
    ls_prvd_eco_cr_3000-token_abbr = is_sourcepool_token_config-token_abbr.
    ls_prvd_eco_cr_3000-token_address = is_sourcepool_token_config-token_address.
    ls_prvd_eco_cr_3000-token_desc = is_sourcepool_token_config-token_desc.
    ls_prvd_eco_cr_3000-token_type = is_sourcepool_token_config-token_type.
    MODIFY zprvdeco3000 FROM ls_prvd_eco_cr_3000.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.

  METHOD zif_prvd_eco_cr_3000~get_defaults.
    DATA: lv_network_id        TYPE zprvd_nchain_networkid,
          lt_source_pooltokens TYPE STANDARD TABLE OF zprvdeco3000.
    IF iv_network_id IS NOT INITIAL.
      lv_network_id = iv_network_id.
    ELSE.
      lv_network_id = '4251b6fd-c98d-4017-87a3-d691a77a52a7'. "polygon mumbai testnet
    ENDIF.

    SELECT * FROM zprvdeco3000 INTO TABLE @lt_source_pooltokens WHERE network_id = @lv_network_id.
    IF sy-subrc <> 0.
    ENDIF.

    READ TABLE lt_source_pooltokens ASSIGNING FIELD-SYMBOL(<fs_source_token>) WITH KEY  token_type = 'S'.
    IF sy-subrc <> 0.
    ELSE.
      rs_defaults-source_token_addr = <fs_source_token>-token_address.
    ENDIF.

    READ TABLE lt_source_pooltokens ASSIGNING FIELD-SYMBOL(<fs_pool_token>) WITH KEY  token_type = 'P'.
    IF sy-subrc <> 0.
    ELSE.
      rs_defaults-pool_token_addr = <fs_pool_token>-token_address.
    ENDIF.

    READ TABLE lt_source_pooltokens ASSIGNING FIELD-SYMBOL(<fs_project_token>) WITH KEY token_type = 'X'.
    IF sy-subrc <> 0.
    ELSE.
      rs_defaults-project_token_addr = <fs_pool_token>-token_address.
    ENDIF.

    rs_defaults-network_id = lv_network_id.


  ENDMETHOD.
ENDCLASS.
