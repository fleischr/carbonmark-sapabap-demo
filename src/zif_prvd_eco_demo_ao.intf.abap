INTERFACE zif_prvd_eco_demo_ao
  PUBLIC .

  TYPES: BEGIN OF ty_atomic_offset,
           atomic_offset_id     TYPE zprvd_eco_atomicoffsetid,
           aggregate_id         TYPE zprvd_eco_carbonaggregateid,
           retirement_id        TYPE zprvd_eco_carbonretirementid,
           atomic_offset_amount TYPE zprvd_eco_carbontonne,
           atomic_offset_uom    TYPE meins,
           objid                TYPE objid,
           objnr                TYPE objnr,
         END OF ty_atomic_offset.

  TYPES: ty_atomic_offset_list TYPE TABLE OF ty_atomic_offset WITH KEY atomic_offset_id.

  METHODS: create IMPORTING is_atomic_offset TYPE ty_atomic_offset.
  METHODS: read IMPORTING iv_atomic_offset_id        TYPE zprvd_eco_atomicoffsetid
                RETURNING VALUE(rv_atomic_offset_id) TYPE ty_atomic_offset.
  METHODS: update IMPORTING is_atomic_offset TYPE ty_atomic_offset.
  METHODS: delete.
  METHODS: query IMPORTING iv_atomic_offset_id     TYPE zprvd_eco_atomicoffsetid OPTIONAL
                           iv_aggregate_id         TYPE zprvd_eco_carbonaggregateid  OPTIONAL
                           iv_retirement_id        TYPE zprvd_eco_carbonretirementid OPTIONAL
                           iv_atomic_offset_amount TYPE zprvd_eco_carbontonne OPTIONAL
                           iv_atomic_offset_uom    TYPE meins OPTIONAL.

  METHODS: map_aggregate_and_retirement IMPORTING is_aggregate            TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010
                                                  is_retirement           TYPE zif_prvd_eco_cr_3030=>ty_carbon_retirement
                                        RETURNING VALUE(rs_atomic_offset) TYPE ty_atomic_offset.

  METHODS: calculate_offset_factor IMPORTING iv_aggregate_id  TYPE zprvd_eco_carbonaggregateid
                                             iv_retirement_id TYPE zprvd_eco_carbonretirementid
                                   EXPORTING ev_offsetfactor  TYPE float.

  METHODS: generate_atomic_offset_id IMPORTING iv_aggregate_id            TYPE zprvd_eco_carbonaggregateid
                                               iv_retirement_id           TYPE zprvd_eco_carbonretirementid
                                     RETURNING VALUE(rv_atomic_offset_id) TYPE zprvd_eco_atomicoffsetid.



ENDINTERFACE.
