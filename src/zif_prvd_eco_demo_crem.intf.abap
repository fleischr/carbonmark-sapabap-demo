INTERFACE zif_prvd_eco_demo_crem
  PUBLIC .

  TYPES: BEGIN OF ty_carbon_aggregate_ca2010,
           aggregate_id  TYPE zprvd_eco_carbonaggregateid,
           objnr         TYPE objnr,
           objid         TYPE objid,
           carbon_amount TYPE zprvd_eco_carbontonne,
           carbon_uom    TYPE meins,
         END OF ty_carbon_aggregate_ca2010.

  TYPES: ty_carbon_aggr_ca2010_list type table of ty_carbon_aggregate_ca2010 with KEY aggregate_id.

  METHODS: create IMPORTING is_carbon_aggregate TYPE ty_carbon_aggregate_ca2010.
  METHODS: read IMPORTING iv_aggregate_id TYPE zprvd_eco_carbonaggregateid
                RETURNING VALUE(rs_carbon_aggregate) TYPE ty_carbon_aggregate_ca2010.
  METHODS: update IMPORTING is_carbon_aggregate TYPE ty_carbon_aggregate_ca2010.
  METHODS: delete IMPORTING iv_aggregate_id TYPE zprvd_eco_carbonaggregateid
                RETURNING VALUE(rs_carbon_aggregate) TYPE ty_carbon_aggregate_ca2010.
  METHODS: query IMPORTING iv_aggregate_id  TYPE zprvd_eco_carbonaggregateid
                           iv_objnr         TYPE objnr
                           iv_objid         TYPE objid
                           iv_carbon_amount TYPE zprvd_eco_carbontonne
                           iv_carbon_uom    TYPE meins
                 RETURNING VALUE(rt_carbon_aggregate_list) type ty_carbon_aggr_ca2010_list .

ENDINTERFACE.
