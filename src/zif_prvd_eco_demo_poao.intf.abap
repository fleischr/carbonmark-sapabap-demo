INTERFACE zif_prvd_eco_demo_poao
  PUBLIC .

  TYPES: BEGIN OF ty_poao_object,
           objnr         TYPE objnr,
           objid         TYPE objid,
           carbon_amount TYPE zprvd_eco_carbontonne,
           carbon_uom    TYPE meins,
         END OF ty_poao_object.

  TYPES: ty_poao_object_list TYPE TABLE OF ty_poao_object WITH KEY objnr objid.

  TYPES: BEGIN OF ty_proof_of_atomic_offset,
           aggregate_id           TYPE zprvd_eco_carbonaggregateid,
           retirement_id          TYPE zprvd_eco_carbonretirementid,
           atomic_offset_id       TYPE zprvd_eco_atomicoffsetid,
           object_type            TYPE objid,
           object_key             TYPE objnr,
           sor_type               TYPE char10,
           total_carbon_aggregate TYPE zprvd_eco_carbontonne,
           carbon_uom             TYPE meins,
           network_id             TYPE zprvd_nchain_networkid,
           tx_hash                TYPE zprvdtxnhash,
         END OF ty_proof_of_atomic_offset.

  METHODS: generate_poao IMPORTING iv_atomic_offset_id TYPE zprvd_eco_atomicoffsetid
                                   is_atomic_offset    TYPE zif_prvd_eco_ao_4010=>ty_atomic_offset OPTIONAL
                                   is_aggregate        TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010 OPTIONAL
                                   is_retirement       TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement OPTIONAL
                         RETURNING VALUE(rs_poao)      TYPE ty_proof_of_atomic_offset.

  METHODS: emit_poao IMPORTING is_poaoa           TYPE ty_proof_of_atomic_offset
                               io_prvd_api_helper TYPE REF TO zcl_prvd_api_helper
                               iv_subj_acct       TYPE zprvdtenantid OPTIONAL
                               iv_workgroupid     TYPE zprvdtenantid OPTIONAL
                     EXPORTING es_poao_zkp        TYPE zbpiobj.

  METHODS: save_proof IMPORTING iv_atomic_offset_id TYPE zprvd_eco_atomicoffsetid
                                is_poao_zkp         TYPE zbpiobj.
ENDINTERFACE.
