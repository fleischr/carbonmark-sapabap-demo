CLASS lhc_ZI_PRVD_ECO_DEMO_0902 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_prvd_eco_demo_0902 RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_prvd_eco_demo_0902 RESULT result.

    METHODS aggregateCarbon FOR MODIFY
      IMPORTING keys FOR ACTION zi_prvd_eco_demo_0902~aggregateCarbon RESULT result.

    METHODS proofOfAtomicOffset FOR MODIFY
      IMPORTING keys FOR ACTION zi_prvd_eco_demo_0902~proofOfAtomicOffset RESULT result.

    METHODS retireCarbon FOR MODIFY
      IMPORTING keys FOR ACTION zi_prvd_eco_demo_0902~retireCarbon RESULT result.

ENDCLASS.

CLASS lhc_ZI_PRVD_ECO_DEMO_0902 IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD aggregateCarbon.
  ENDMETHOD.

  METHOD proofOfAtomicOffset.
  ENDMETHOD.

  METHOD retireCarbon.
  ENDMETHOD.

ENDCLASS.
