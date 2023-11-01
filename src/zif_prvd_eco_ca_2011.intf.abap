INTERFACE zif_prvd_eco_ca_2011
  PUBLIC .

    TYPES: BEGIN OF ty_carbon_aggr_meta_ca2011,
           aggregate_id  TYPE zprvd_eco_carbonaggregateid,
           objnr         TYPE objnr,
           objid         TYPE objid,
           carbon_amount TYPE zprvd_eco_carbontonne,
           carbon_uom    TYPE meins,
         END OF ty_carbon_aggr_meta_ca2011.


  METHODS: create IMPORTING is_carbon_aggregate TYPE ty_carbon_aggr_meta_ca2011.
  METHODS: read IMPORTING iv_aggregate_id TYPE zprvd_eco_carbonaggregateid
                          iv_objnr        TYPE objnr
                          iv_objid        TYPE objid.
  METHODS: update IMPORTING is_carbon_aggregate TYPE ty_carbon_aggr_meta_ca2011.
  METHODS: delete.
  METHODS: query IMPORTING iv_aggregate_id  TYPE zprvd_eco_carbonaggregateid
                           iv_objnr         TYPE objnr
                           iv_objid         TYPE objid
                           iv_carbon_amount TYPE zprvd_eco_carbontonne
                           iv_carbon_uom    TYPE meins.


ENDINTERFACE.
